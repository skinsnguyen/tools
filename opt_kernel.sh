opt_tcp() {
#######################################################
# check if custom open file descriptor limits already exist
    LIMITSCONFCHECK=`grep '* hard nofile 524288' /etc/security/limits.conf`
    if [[ -z $LIMITSCONFCHECK ]]; then
        # Set VPS hard/soft limits
        echo "* soft nofile 524288" >>/etc/security/limits.conf
        echo "* hard nofile 524288" >>/etc/security/limits.conf
# https://community.centminmod.com/posts/52406/
if [[ "$CENTOS_SEVEN" = '7' && ! -f /etc/rc.d/rc.local ]]; then


cat > /usr/lib/systemd/system/rc-local.service <<EOF
# This unit gets pulled automatically into multi-user.target by
# systemd-rc-local-generator if /etc/rc.d/rc.local is executable.
[Unit]
Description=/etc/rc.d/rc.local Compatibility
ConditionFileIsExecutable=/etc/rc.d/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.d/rc.local start
TimeoutSec=0
RemainAfterExit=yes
EOF

cat > /etc/rc.d/rc.local <<EOF
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.

touch /var/lock/subsys/local
EOF

# remove non-standard centos 7 service file if detected
if [ -f /etc/systemd/system/rc-local.service ]; then
  echo "cat /etc/systemd/system/rc-local.service"
  cat /etc/systemd/system/rc-local.service
  echo
  rm -rf /etc/systemd/system/rc-local.service
  rm -rf /var/lock/subsys/local
  systemctl daemon-reload
  systemctl stop rc-local.service
fi

  chmod +x /etc/rc.d/rc.local
  pushd /etc; ln -s rc.d/rc.local /etc/rc.local; popd
  systemctl daemon-reload
  systemctl start rc-local.service
  systemctl status rc-local.service
fi
        ulimit -n 524288
        echo "ulimit -n 524288" >> /etc/rc.local
        if [[ ! "$(grep '/var/run/php-fpm' /etc/rc.local)" ]]; then
          echo 'if [ ! -d /var/run/php-fpm/ ]; then mkdir -p /var/run/php-fpm/; fi' >> /etc/rc.local
        fi
    fi # check if custom open file descriptor limits already exist

    if [[ "$CENTOS_SEVEN" = '7' ]]; then
        # centos 7
        if [[ -f /etc/security/limits.d/20-nproc.conf ]]; then
cat > "/etc/security/limits.d/20-nproc.conf" <<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

*          soft    nproc     8192
*          hard    nproc     8192
nginx      soft    nproc     32278
nginx      hard    nproc     32278
root       soft    nproc     unlimited
EOF
      fi
    else
        # centos 6
        if [[ -f /etc/security/limits.d/90-nproc.conf ]]; then
cat > "/etc/security/limits.d/90-nproc.conf" <<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

*          soft    nproc     8192
*          hard    nproc     8192
nginx      soft    nproc     32278
nginx      hard    nproc     32278
root       soft    nproc     unlimited
EOF
        fi # raise user process limits
    fi

if [[ ! -f /proc/user_beancounters ]]; then
    if [[ "$CENTOS_SEVEN" = '7' ]]; then
        if [ -d /etc/sysctl.d ]; then
            # centos 7
            touch /etc/sysctl.d/101-sysctl.conf
            if [[ "$(grep 'centminmod added' /etc/sysctl.d/101-sysctl.conf >/dev/null 2>&1; echo $?)" != '0' ]]; then
            # raise hashsize for conntrack entries
            echo 65536 > /sys/module/nf_conntrack/parameters/hashsize
            if [[ "$(grep 'hashsize' /etc/rc.local >/dev/null 2>&1; echo $?)" != '0' ]]; then
              echo "echo 65536 > /sys/module/nf_conntrack/parameters/hashsize" >> /etc/rc.local
            fi
cat >> "/etc/sysctl.d/101-sysctl.conf" <<EOF
# centminmod added
kernel.pid_max=65536
kernel.printk=4 1 1 7
fs.nr_open=12000000
fs.file-max=9000000
net.core.wmem_max=16777216
net.core.rmem_max=16777216
net.ipv4.tcp_rmem=8192 87380 16777216                                          
net.ipv4.tcp_wmem=8192 65536 16777216
net.core.netdev_max_backlog=65536
net.core.somaxconn=65535
net.core.optmem_max=8192
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_keepalive_time=240
net.ipv4.tcp_max_syn_backlog=65536
net.ipv4.tcp_sack=1
net.ipv4.tcp_syn_retries=3
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_tw_buckets = 1440000
vm.swappiness=10
vm.min_free_kbytes=65536
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_limit_output_bytes=65536
net.ipv4.tcp_rfc1337=1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.netfilter.nf_conntrack_helper=0
net.nf_conntrack_max = 524288
net.netfilter.nf_conntrack_tcp_timeout_established = 28800
net.netfilter.nf_conntrack_generic_timeout = 60
net.ipv4.tcp_challenge_ack_limit = 999999999
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_base_mss = 1024
net.unix.max_dgram_qlen = 4096
EOF
        if [[ "$(grep -o 'AMD EPYC' /proc/cpuinfo | sort -u)" = 'AMD EPYC' ]]; then
          echo "kernel.watchdog_thresh = 20" >> /etc/sysctl.d/101-sysctl.conf
        fi
        /sbin/sysctl --system
            fi           
        fi
    else
        # centos 6
        if [[ "$(grep 'centminmod added' /etc/sysctl.conf >/dev/null 2>&1; echo $?)" != '0' ]]; then
            # raise hashsize for conntrack entries
            echo 65536 > /sys/module/nf_conntrack/parameters/hashsize
            if [[ "$(grep 'hashsize' /etc/rc.local >/dev/null 2>&1; echo $?)" != '0' ]]; then
              echo "echo 65536 > /sys/module/nf_conntrack/parameters/hashsize" >> /etc/rc.local
            fi
cat >> "/etc/sysctl.conf" <<EOF
# centminmod added
kernel.pid_max=65536
kernel.printk=4 1 1 7
fs.nr_open=12000000
fs.file-max=9000000
net.core.wmem_max=16777216
net.core.rmem_max=16777216
net.ipv4.tcp_rmem=8192 87380 16777216                                          
net.ipv4.tcp_wmem=8192 65536 16777216
net.core.netdev_max_backlog=65536
net.core.somaxconn=65535
net.core.optmem_max=8192
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_keepalive_time=240
net.ipv4.tcp_max_syn_backlog=65536
net.ipv4.tcp_sack=1
net.ipv4.tcp_syn_retries=3
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_tw_buckets = 1440000
vm.swappiness=10
vm.min_free_kbytes=65536
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_rfc1337=1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.netfilter.nf_conntrack_helper=0
net.nf_conntrack_max = 524288
net.netfilter.nf_conntrack_tcp_timeout_established = 28800
net.netfilter.nf_conntrack_generic_timeout = 60
net.ipv4.tcp_challenge_ack_limit = 999999999
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_base_mss = 1024
EOF
sysctl -p
        fi
    fi # centos 6 or 7
fi
}
