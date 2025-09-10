
# No kerberos here...

#
# Add some panic contraints in case of fail
#
echo "vm.panic_on_oom=1   ;enables panic on OOM">>/etc/sysctl.conf
echo "kernel.panic=10     ;tells the kernel to reboot ten seconds after panicking">>/etc/sysctl.conf


# install others
apt install -y htop vim sshpass ansible python3-virtualenv htop curl wget git python-is-python3 screen rsync
mkdir /etc/ansible



# configure NTP
cp files/ntp/timesyncd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status


apt install -y libnss-ldap
apt install -y libnss-ldapd
/etc/init.d/nscd restart
/etc/init.d/ssh restart
getent passwd

reboot now
