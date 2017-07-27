```cpp

// healthd

.battery_update = healthd_mode_android_battery_update {
    gBatteryPropertiesRegistrar->notifyListeners() {
        mListeners->batteryPropertiesChanged() {
            transact(TRANSACT_BATTERYPROPERTIESCHANGED)
        }
    }
}

// BatteryService

BatteryListener.batteryPropertiesChanged() {
    BatteryService.update() {
        update light and icon staff... all in it.
    }
}

```
