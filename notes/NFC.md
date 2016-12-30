+---------------+         +-----------+ Phy  : I2C  +------------+
| Reader/Writer |   RF    |           | Logic: NCI  |    Host    |
|      or       |<=======>| Carrillon |<===========>| Controller |
|     Card      |         |           |             |    (SW?)   |
+---------------+         +-----------+             +------------+

## Android NFC framework

                               AIDL
        Nfc APP as Service  -----------  Nfc framework part as Client
               |
               |
               |
         jni of Nfc APP
               |
libnfc-nci     |
      +--------+--------+
      |  NfcAdaptation  |
      |        |        |
      |        |        |
      |     halimpl     |
      +--------+--------+
               | /dev/cxd224-i2c
               |
          cxd224 driver


*Reading from NFC tag*

1. The Android tag dispatch system parse the scanned tag and figure out the MIME type
or a URI that identifies the data payload in the tag.

2. Encapsulating the MIME type or URI and the payload into an intent.

3. Starts an activity based on the intent.

*Writing to NFC tag*

Create NFC records, encapsulate them info an NFC message (defined by NDEF).


## Flow

``` cpp

nfcManager_doInitialize() {         // APP JNI
    theInstance = NfcAdaptation::GetInstance();

    /* start GKI, NCI task, NFC task */
    theInstance.Initialize() {
        GKI init and enable;
        create NFC_TASK;
        InitializeHalDeviceContext() {
            get NCI HAL module (provided by libnfc-nci halimpl) and open,
	    fill mHalDeviceContext with halimpl methods;
        }
    }

    NFA_Init(theInstance.GetHalEntryFuncs()) {
        install nfa subsystems control blocks into nfa_sys_cb;
        install NfcAdaptation Hal functions to NFA layer, NFC module;
    }

    /* Enable NFC and tasks needed.
       Open NCI transport.
       Reset NFC controller, download patches to NFCC.
       Initilize NFC subsys. */
    NFA_Enable(/* NFA_DM_CBACK */ nfaDeviceManagementCallback,
            /* NFA_CONN_CBACK */ nfaConnectionCallback) {
        nfa_sys_sendmsg(p_msg={->hdr.event = NFA_DM_API_ENABLE_EVT
                /* will be handled by
                   nfa_dm_enable() {hal method hal_open()} */}) {
            GKI_send_msg(NFC_TASK,
                    /* mbox indicates evt type -- how it will be handled */
                    p_nfa_sys_cfg->mbox /* = NFA_MBOX_ID = TASK_MBOX_2,
                                         * will be handled by
                                         * nfa_sys_event */,
                    p_msg);
        }
    }
}

```

             RPC             RPC
`NfcService`----->`NFC_TASK`----->`NFC_HAL_TASK`
