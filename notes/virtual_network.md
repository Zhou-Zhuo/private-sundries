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
