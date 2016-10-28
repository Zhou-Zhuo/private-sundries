```c

struct mountpoint {
        struct list_head m_hash;
        struct dentry *m_dentry;
        int m_count;
};

struct mount {
	/* list node, link到mount_hashtable中的一个element, key为由
	 * ->mnt_parent->mnt和->mnt_mountpoint组成的tuple(刚好是mount point
	 * 对应的path对象). 也就是说，挂在同一个路径下的mount会挂在同一个
	 * list下.将此node link到mount_hashtable中是graft_tree()过程的关键
	 * 一步 */
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

mount一个新的device大致可分为两步:
1. load superblock and root inode, 从root inode中创建root dentry; (`vfs_kern_mount`)
2. 将new mount嫁接到parent mount上对应mount point上. (`do_add_mount`=>`graft_tree`)

从上面步骤也可以看出`mount`的目的:
- 为新的device加载filesystem, 为I/O提供条件
- 将新的device加入到path tree里面, 为path walking提供条件

path resolution: 以path name解析path, open()及stat()时进行.
方法: walking namespace tree, 从第一个已知的dentry (root or cwd)开始，不断walk child

**A path is represented as a (dentry, vfsmount) tuple, 也就是说，单靠一个dentry是无法
表示一个path的信息的，我们还需要知道path属于哪个mount.**
path walking 遇到mount point 时就会change到child的vfsmount, 从mount point处的path切
换到对应vfsmount的root path.
