## How does bridge get incomming data from device ?

```c

// install
br_add_if(br, dev) {
	netdev_rx_handler_register(dev, br_handle_frame, ..);
}

// when data incomming
__netif_receive_skb_core(skb, ..) {
	deliver stuff...
	skb->dev->rx_handler(skb, ..) /* br_handle_frame() */ {
		if ((dst = __br_fdb_get(br, ..)) && dst->is_local) {
			skb2 = skb;
			skb = NULL;
		}
		if (skb)
			br_forward(dst, skb, skb2);
		if (skb2)
			br_pass_frame_up(skb2) {
				// rx statistics of bridge happens here
			}
	}
}

```
