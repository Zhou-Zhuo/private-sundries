/data/tombstones

HAL provided virtual sensors VS. Android virtual sensors

`GRAVITY` `LINEAR_ACCELERATION` `ROTATION_VECTOR` all virtual?
----

Android Sensors

`SensorDevice`: 与HAL层的接口类, 是一个Singleton

* 数据成员:

  内部维持着一个`Info` Vector, 每个sensor对应一个`Info`结构. `Info`结构内部维持一个`BatchParams` Vector, 每个client对应一个`BatchParams`结构. `BatchParams`存储`batch` call的参数.

* 接口函数:

  `activate`, `batch`, `setDelay`, `flush` 等函数都有`ident`和`handle`两个参数, 其中`ident`用来标识`client`, handle用来标识sensor.

  `activate()`操作接在`batch()`后面, `activate()`首次被调用需要调用HAL层的`activate`操作.

Sensors HAL
  从/sys/class/sensors中获得信息填充`SensorContext`, 并获得input event path.

native sensorservice

----

几种架构：

1. `kernel/arch/arm/mach-msm/sensors_adsp.c` + `vendor/qcom/proprietary/sensors/dsps`

2. linux input subsys + `hardware/qcom/sensors`

3. linux iio subsys + `hardware/invensense`
