``` sh

# create network namespace nns0
ip netns add nns0

# create veth pair veth0 veth1
ip link add veth0 type veth peer name veth1

# setup veth0
ip link set veth0 up
ip addr add 192.168.2.1/24 dev veth0

# join veth1 to nns0
ip link set veth1 netns nns0

# enable NAT
sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE

# launch a namespace nns0 environment
ip netns exec nns0 zsh

# INSIDE namespace nns0 environment
# setup veth1
ip link set veth1 up
ip addr add 192.168.2.2/24 dev veth1
ip route add default via 192.168.2.1

```

Let's get 2 "machines"!

``` sh

sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
ip link add veth0 type veth peer name vp0
ip link add veth1 type veth peer name vp1
brctl addbr br0
brctl addif br0 vp0 vp1
ip link set vp0 up
ip link set vp1 up
ip link set br0 up
ip addr add 192.168.2.1/24 dev br0
ip netns add nns0
ip netns add nns1
ip link set dev veth0 netns nns0
ip link set dev veth1 netns nns1
ip netns exec nns0 ip link set veth0 up
ip netns exec nns0 ip addr add 192.168.2.2/24 dev veth0
ip netns exec nns0 ip route add default via 192.168.2.1
ip netns exec nns1 ip link set veth1 up
ip netns exec nns1 ip addr add 192.168.2.3/24 dev veth1
ip netns exec nns1 ip route add default via 192.168.2.1

```

Enjoy!
