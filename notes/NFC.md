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
            hw_get_module("nfc_nci.cxd224x", &hw_module);
            // hw_module = { .open = nfc_open };
            nfc_nci_open(/* module = */ hw_module, /* dev = */ &mHalDeviceContext) {
                module->open() /* == nfc_open(dev) */ {
                    dev->nci_device.open = hal_open;
                    fill other methods;
                }
            }
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

---

NativeNfcTag: when discovery a tag, launch mWatchdog, check for tag gone.

``` java

NfcService.onRemoteEndpointDiscovered () {
    sendMessage(MSG_NDEF_TAG)
}

NfcServiceHandler.handleMessage() {
    case MSG_NDEF_TAG:
        tag.startPresenceChecking() {
            mWatchdog.start();
        }
        dispatchTagEndpoint(tag, readerParams);
}

```

in libnfc-nci:

```c

// when recv something

/* USERIAL_HAL_TASK */
userial_read_thread() {
    for (;..;) {
        my_read(linux_cb.sock,..);
        GKIH_enqueue(&Userial_in_q, p_buf);
        /* linux_cb.ser_cb = nfc_hal_main_userial_cback,assigned on
           USERIAL_Open() */
        (*linux_cb.ser_cb)(linux_cb.port, USERIAL_RX_READY_EVT, p_buf)
        /* nfc_hal_main_userial_cback() */ {
            GKI_send_event (NFC_HAL_TASK, NFC_HAL_TASK_EVT_DATA_RDY);
        }
    }
}

/* NFC_HAL_TASK */
nfc_hal_main_task() {
    while(1) {
        event = GKIH_wait(0xFFFF, 0);

        if (event & NFC_HAL_TASK_EVT_DATA_RDY) {
            while (TRUE) {
                USERIAL_Read(USERIAL_NFC_PORT, &byte, 1) {
                    GKIH_enqueue(&Userial_in_q);
                }
                /*
                 * type ncit_cb {
                 *  NFC_HDR *p_rcv_msg;
                 *  // note: NCI msg can be fragmented.
                 *  // p_frag_msg just be used in nfc_hal_nci_assemble_nci_msg,
                 *  // i.e., for reassembling. After reassembling, set to NULL.
                 *  NFC_HDR *p_frag_msg;
                 *  NFC_HDR *p_pend_cmd;
                 *  }
                 *
                 */
                /* copy msg to p_rcv_msg */
                nfc_hal_nci_receive_msg(byte) {
                    nfc_hal_cb.ncit_cb.rcv_state:
                        NFC_HAL_RCV_IDLE_ST => NFC_HAL_RCV_NCI_MSG_ST
                        nfc_hal_nci_receive_nci_msg() {
                            // rcv_state:
                            // NFC_HAL_RCV_NCI_MSG_ST => NFC_HAL_RCV_NCI_HDR_ST
                            // => NFC_HAL_RCV_NCI_PAYLOAD_ST => NFC_HAL_RCV_IDLE_ST
                            copy message to nfc_hal_cb.ncit_cb.p_rcv_msg
                        }
                }
                nfc_hal_nci_assemble_nci_msg() {
                    keep assembling msg to p_frag_msg till last fragment recved
                }
                if (reassembling done) {
                    nfc_hal_nci_preproc_rx_nci_msg(p_rcv_msg);
                    /* send NCI msg to the stack */
                    nfc_hal_send_nci_msg_to_nfc_task(p_rcv_msg) {
                        p_data_cback()
                            /* = NfcAdaptation::HalDeviceContextDataCallback() */ {
                                mHalDataCallback /* = nfc_main_hal_data_cback */ {
                                    GKI_send_msg (NFC_TASK, NFC_MBOX_ID, p_msg
                                            /* = { .event = BT_EVT_TO_NFC_NCI } */);
                            }
                        }
                    }
                }
            }
        }
    }
}

nfc_task () {
    while (TRUE) {
        event = GKI_wait(0xFFFF, 0);
        if (event & NFC_MBOX_EVT_MASK) {
            while ((p_msg = GKI_read_mbox (NFC_MBOX_ID)) != NULL) {
                switch (p_msg->event & BT_EVT_MASK) {
                    case BT_EVT_TO_NFC_NCI:
                        nfc_ncif_process_event(p_msg) {
                            NCI_MSG_PRS_HDR0 (pp, mt, pbf, gid);
                            switch (mt) {
                                // ...
                                switch (gid) {
                                    // ...
                                }
                            }
                        }
                        break;
                }
            }
        }
    }
}

```
