* `joinThreadPool()` is the main loop.

  `BR_SPAWN_LOOPER` cmd
   => `new PoolThread()`
    => `threadLoop -> joinThreadPool()`

* `IPCThreadState` is a TLS object, a per-thread-sigleton. Thread get its instance
   of `IPCThreadState` by calling `IPCThreadState::self()`.

* __HOWTO__:

  *server side create service:*

```cpp

    defaultServiceManager()->addService(String16("fooservice"), new FooService());

```

  *client side get service:*

```cpp

    sp<IBinder> binder = defaultServiceManager()->getService(String16("fooservice"));
    // this returns FooService::asInterface(binder);
    sp<IFooService> service = interface_cast<IFooService>(binder).get;
    service.sayHello();

```

 *interface stuff:*

```cpp

class IFooService : public IInterface
{
public:
    // this declares:
    // sp<IFooService> asInterface(sp<IBinder>& obj);
    DECLARE_META_INTERFACE(FooService);

    virtual void sayHello();
};

class BpFooService : public BpInterface<IFooService>
{
public:
    void sayHello()
    {
        remote()->transact(SAY_HELLO, data, &reply);
    }
};

class BnFooService : public BnInterface<IFooService>
{
public:
    virtual status_t onTrasact(uint32_t code, const Parcel& data,
            Parcel *reply, uint32_t flags);
};

// this defines:
// sp<IFooService> asInterface(sp<IBinder>& obj)
// {
//     return new BpFooService(obj); // for short, actually sigleton
// }
IMPLEMENT_META_INTERFACE(FooService, "android.foo.IFooService");

status_t BnFooService::onTransact(
        uint32_T code, const Parcel& data, Parcel* reply, uint32_t flags)
{
    switch (code) {
        case SAY_HELLO:
            sayHello();
            return NO_ERROR;
        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
}

```
