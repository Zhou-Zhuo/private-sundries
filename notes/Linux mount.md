##### *Hash*

内核用一个链表数组的方式实现一个hash table,寻址用数组,之所以要用链表是为了处理
地址碰撞(地址碰撞的元素链在一个list上).所以寻址过程除了用hash key索引到目的链表
表头,如果链表中不止一个元素,还要沿着链表比较raw key.

## Mount

相关数据结构:

```c

struct mountpoint {
	struct list_head m_hash;
	struct dentry *m_dentry;
	int m_count;
};

struct mount {
	/* list node, link到mount_hashtable中的一个element, key为由
	 * ->mnt_parent->mnt和->mnt_mountpoint组成的tuple(刚好是mount point
	 * 对应的path对象). 将此node link到mount_hashtable中是graft_tree()过程
	 * 的关键一步 */
	struct list_head mnt_hash;

	/* dest_path的mount即此处的mnt_parent.即,上一级dev的mount */
	struct mount *mnt_parent;
	struct dentry *mnt_mountpoint;
	struct vfsmount mnt;

	int mnt_count;
	int mnt_writers;

	struct list_head mnt_mounts;    /* list of children, anchored here */
	struct list_head mnt_child;     /* and going through their mnt_child */
	struct list_head mnt_instance;  /* mount instance on sb->s_mounts */
	const char *mnt_devname;        /* Name of device e.g. /dev/dsk/hda1 */
	struct list_head mnt_list;
	struct list_head mnt_expire;    /* link in fs-specific expiry list */
	struct list_head mnt_share;     /* circular list of shared mounts */
	struct list_head mnt_slave_list;/* list of slave mounts */
	struct list_head mnt_slave;     /* slave list entry */
	struct mount *mnt_master;       /* slave is on master->mnt_slave_list */
	struct mnt_namespace *mnt_ns;   /* containing namespace */
	struct mountpoint *mnt_mp;      /* where is it mounted */

	int mnt_id;                     /* mount identifier */
	int mnt_group_id;               /* peer group identifier */
	int mnt_expiry_mark;            /* true if marked for expiry */
	int mnt_pinned;
	int mnt_ghosts;
};

```

* **A path is represented as a (dentry, vfsmount) tuple, 也就是说，单靠一个dentry
是无法表示一个path的信息的，我们还需要知道path属于哪个mount.**

mount一个新的device大致可分为两步:

1. load superblock and root inode, 从root inode中创建root dentry; (`vfs_kern_mount`)

2. 将new mount嫁接到parent mount上对应mount point上.
( `do_add_mount` => `graft_tree` )

从上面步骤也可以看出`mount`的目的:

* 为新的device加载filesystem, 为I/O提供条件

* 将新的device加入到path tree里面, 为path walking提供条件

#### *RCU*

以链表为例,在若干线程读取一个节点时,另一个线程删除该节点,删除线程将节点移除链表,却不
马上销毁,真正的销毁操作需等到读取线程释放节点的引用时才进行.从删除操作到销毁操作中间
的时间称为宽限期(grace period).相关API: `rcu_read_(un)lock`,`synchronize_rcu`

同样,在插入节点时需保证读取线程读到的是完整的节点,这需要rcu API的指针相关操作(如
`rcu_assign_pointer`,`rcu_dereference - fetch RCU-protected pointer for
dereferencing`), 这些操作往往封装了内存屏障.

#### *seqlock*

除非已有writer thread加锁, 否则writer thread直接获取lock, 不管是否已被reader thread
加锁. reader thread在退出临界区时判断临界区内是否有writer thread, 如果有则retry read
操作. 实现方法是维持一个seq counter, 初始化为0, write lock和unlock操作均令其加一,
reader等seq为偶数时才允许进入临界区, reader离开临界区时判断seq是否改变, 如果改变说明
期间有writer更新了seq, 则重试.

```c

void reader_thread()
{
	do {
		seq = read_seqbegin(&seqlock);
		// do reader stuff
	} while (read_seqretry(&seqlock, seq));
}

void writer_thread()
{
	write_seqlock(&seqlock);
	// do writer stuff
	write_sequnlock(&seqlock);
}

```

## Path Resolution and Dcache

path resolution: 以path name解析path, open()及stat()时进行.

方法: walking namespace tree, 从第一个已知的dentry (root or cwd)开始，不断walk
child.对于已经walk到的dentry, 会以dcache的方式加速下次resolution (见下面代码注释).

path walking 遇到mount point 时就会change到child的vfsmount, 从mount point处的path切
换到对应vfsmount的root path.

`nameidata` -- 表示path walking过程内部状态的一个结构(state machine).

相关数据结构:

```c

struct qstr {
	union {
		struct {
			u32 hash;
			u32 len;
		};
		u64 hash_len;
	};
	const unsigned char *name;
};

/* path reslution 过程中存储状态的结构变量 */
struct nameidata {
	/* 当前walk到的目录,这个域会随path walking过程行进而更新.
	 * flag AT_FDCWD置位时被初始化为pwd */
	struct path     path;

	/* quick string -- 包含string本身和其hash. dcache hashtable
	 * 用tuple (parent, qstr->hash)作key */
	struct qstr     last;
	struct path     root;
	struct inode    *inode; /* path.dentry.d_inode */
	unsigned int    flags;
	unsigned        seq;
	int             last_type;
	unsigned        depth;
	char *saved_names[MAX_NESTED_LINKS + 1];
};

struct dentry {
	/* RCU lookup touched fields */
	unsigned int d_flags;           /* protected by d_lock */
	seqcount_t d_seq;               /* per dentry seqlock */

	/* dentry_hashtable(也即dcache-hash table)中的bucket, key为
	   tuple (parent, name), 其中parent是parent dentry, name并非raw name
	   而是qstr类型name的hash. 这个域组成的hash table是dcache的关键. */
	struct hlist_bl_node d_hash;    /* lookup hash list */
	struct dentry *d_parent;        /* parent directory */
	struct qstr d_name;
	struct inode *d_inode;          /* Where the name belongs to - NULL is
					 * negative */
	unsigned char d_iname[DNAME_INLINE_LEN];        /* small names */

	/* Ref lookup also touches following */
	unsigned int d_count;           /* protected by d_lock */
	spinlock_t d_lock;              /* per dentry lock */
	const struct dentry_operations *d_op;
	struct super_block *d_sb;       /* The root of the dentry tree */
	unsigned long d_time;           /* used by d_revalidate */
	void *d_fsdata;                 /* fs-specific data */

	struct list_head d_lru;         /* LRU list */
	/*
	 * d_child and d_rcu can share memory
	 */
	union {
		struct list_head d_child;       /* child of parent list */
		struct rcu_head d_rcu;
	} d_u;
	struct list_head d_subdirs;     /* our children */
	struct hlist_node d_alias;      /* inode alias list */
};

```

一个疑问: 按照我的理解, 从`dentry_hashtable`中找到bucket后如果事先判断其bucket中
只有一个元素应该就可以确定hash不存在碰撞了, 也就不用再去比较字符串了, 然而内核里
面却不是这样做的( `__d_lookup_rcu` => `dentry_cmp` ) (并且还专门写了个
`dentry_string_cmp`).
