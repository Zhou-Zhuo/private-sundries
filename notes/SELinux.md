###Domain Transition

init进程fork service时会发生Domoin Transition. 实现DT的方法有两种:

1. 对于SELinux-aware程序,可以用`setexeccon()`来设置`exec()`调用将进程所label的
   context. 与此同时，必须声明这一规则:
   `allow init self:process setexec;`

2. 对于非SELinux-aware程序,可以用声明
   `type_transition init daemon_exec:process daemon;`
   这一语句的效果是`init` type的进程对`daemon_exec` type的binary执行exec()调用
   自动transition到`daemon` type. 与此同时,必须声明这一规则:
   `allow init daemon:process transition;`

* 从以上可以看出class `process`对应的并非实际意义上的process,而是executable binary.

###MLS

MLS的关注点在于信息的secret level，不管是subject还是object。

信息可以从subject流向object，这是write，

信息可以从object流向subject，这是read，

无论subject还是object都有MLS Level，MLS规定信息不能从high secret level流向low secret level
