#🔐 FULL HARDENING MIKROTIK

# ===== DEFINE =====
:local WAN "ether1"
:local LAN "bridge"

# ===== ADDRESS LIST =====
/ip firewall address-list
add list=mgmt_allow address=192.168.1.0/24 comment="LAN"
# add list=mgmt_allow address=YOUR_PUBLIC_IP comment="Remote admin"

# ===== PORT KNOCKING =====
# Bước 1
add chain=input in-interface=$WAN protocol=tcp dst-port=1001 \
    action=add-src-to-address-list address-list=knock1 address-list-timeout=30s

# Bước 2
add chain=input in-interface=$WAN protocol=tcp dst-port=2002 \
    src-address-list=knock1 \
    action=add-src-to-address-list address-list=knock2 address-list-timeout=30s

# Bước 3 (mở quyền quản trị)
add chain=input in-interface=$WAN protocol=tcp dst-port=3003 \
    src-address-list=knock2 \
    action=add-src-to-address-list address-list=mgmt_allow address-list-timeout=1h

# ===== RAW (DROP SỚM) =====
/ip firewall raw
add chain=prerouting src-address-list=blacklist action=drop
add chain=prerouting src-address-list=port_scanner action=drop
add chain=prerouting src-address-list=ddos_attack action=drop

# ===== FILTER =====
/ip firewall filter

# 1. BASIC
add chain=input connection-state=established,related action=accept
add chain=input connection-state=invalid action=drop

# 2. ALLOW LAN / MGMT
add chain=input src-address-list=mgmt_allow action=accept

# 3. DROP BLACKLIST NGAY
add chain=input src-address-list=blacklist action=drop
add chain=input src-address-list=port_scanner action=drop
add chain=input src-address-list=ddos_attack action=drop

# ===== ANTI PORT SCAN =====
add chain=input protocol=tcp psd=21,3s,3,1 \
    action=add-src-to-address-list address-list=port_scanner address-list-timeout=1d

# NULL scan
add chain=input protocol=tcp tcp-flags=none \
    action=add-src-to-address-list address-list=port_scanner address-list-timeout=1d

# FIN scan
add chain=input protocol=tcp tcp-flags=fin,!syn,!rst,!psh,!ack,!urg \
    action=add-src-to-address-list address-list=port_scanner address-list-timeout=1d

# XMAS scan
add chain=input protocol=tcp tcp-flags=fin,psh,urg,!syn,!rst,!ack \
    action=add-src-to-address-list address-list=port_scanner address-list-timeout=1d

# ===== ANTI BRUTE FORCE =====

# Stage 1
add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    action=add-src-to-address-list address-list=bf1 address-list-timeout=1m

# Stage 2
add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    src-address-list=bf1 \
    action=add-src-to-address-list address-list=bf2 address-list-timeout=5m

# Stage 3
add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    src-address-list=bf2 \
    action=add-src-to-address-list address-list=bf3 address-list-timeout=15m

# Blacklist
add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    src-address-list=bf3 \
    action=add-src-to-address-list address-list=blacklist address-list-timeout=1d

# ===== ANTI DDoS =====

# SYN flood detect
add chain=input protocol=tcp tcp-flags=syn connection-limit=30,32 \
    action=add-src-to-address-list address-list=ddos_attack address-list-timeout=10m

# connection flood
add chain=input connection-state=new connection-limit=50,32 \
    action=add-src-to-address-list address-list=ddos_attack address-list-timeout=10m

# ===== RATE LIMIT MGMT =====
add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    limit=5,10 action=accept

add chain=input in-interface=$WAN protocol=tcp dst-port=22,8291 connection-state=new \
    action=drop

# ===== ICMP =====
add chain=input protocol=icmp limit=5,10 action=accept
add chain=input protocol=icmp action=drop

# ===== FINAL DROP WAN =====
add chain=input in-interface=$WAN action=drop

###############################################################################################
###############################################################################################

# ===== HTTP/HTTPS DDOS PROTECT (STRONG) =====

add chain=input protocol=tcp dst-port=80,443 connection-limit=100,32 \
    action=add-src-to-address-list address-list=ddos_attack address-list-timeout=10m

add chain=input src-address-list=ddos_attack action=drop

###############################################################################################
# ===== HTTP/HTTPS RATE LIMIT =====

# Cho phép mức bình thường
add chain=input in-interface=$WAN protocol=tcp dst-port=80,443 connection-state=new \
    limit=50,100 action=accept comment="allow web normal"

# Nếu vượt ngưỡng → đưa vào danh sách theo dõi
add chain=input in-interface=$WAN protocol=tcp dst-port=80,443 connection-state=new \
    action=add-src-to-address-list address-list=web_flood address-list-timeout=5m \
    comment="detect web flood"

# Nếu tiếp tục spam → blacklist
add chain=input src-address-list=web_flood protocol=tcp dst-port=80,443 \
    action=add-src-to-address-list address-list=blacklist address-list-timeout=1h \
    comment="web flood blacklist"
############################################################################################

