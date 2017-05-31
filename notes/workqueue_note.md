**NOTE**

* Workqueue, sounds like a serialized executable queue, right? Well, in sigle-CPU
case it's true. In case of multi-CPUs, this is not guaranteed, unless flag
`WQ_NON_REENTRANT` were set.


A good way to pass args to `work_struct`:

Define a work wrapper struct, alloc a new wrapper each time you want to start a
work. If the work is to run async-ly (i.e. you will not flush the work), the
clean job is to be done inside the work func.
