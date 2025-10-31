

apt install -y screen rsync



# install kerberos
apt install -y krb5-config krb5-user
apt install -y libpam-krb5
apt install -y linux-headers-$(uname -r)

kadmin -q "addprinc -policy service -randkey host/$HOSTNAME.lps.ufrj.br"
kadmin -q "ktadd -k /etc/krb5.keytab host/$HOSTNAME.lps.ufrj.br"



# install LDAP
apt install -y libnss-ldap
apt install -y libnss-ldapd
/etc/init.d/nscd restart
/etc/init.d/ssh restart
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=022" >> /etc/pam.d/common-session
getent passwd

# configure SSH
cp files/common/sshd_config /etc/ssh
invoke-rc.d ssh restart



# configure NTP
cp files/common/timesynd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status


# Configure home folder
echo "10.1.1.202:/volume1/homes /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
mkdir /etc/pam_scripts
chmod -R 700 /etc/pam_scripts
chown -R root:root /etc/pam_scripts
cp files/common/login-logger.sh /etc/pam_scripts
chmod +x /etc/pam_scripts/login-logger.sh
echo "session required pam_exec.so /etc/pam_scripts/login-logger.sh" >> /etc/pam.d/sshd


#
# Install others
#
apt install -y python3-virtualenv htop vim curl wget git sshpass python-is-python3 screen


#
# Add some panic contraints in case of fail
#
echo "vm.panic_on_oom=1   ;enables panic on OOM">>/etc/sysctl.conf
echo "kernel.panic=10     ;tells the kernel to reboot ten seconds after panicking">>/etc/sysctl.conf



#
# Install pyenv
#
curl https://pyenv.run | bash
echo ''
echo '# setup pyenv' >> /etc/bash.bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /etc/bash.bashrc
echo 'eval "$(pyenv init --path)"' >> /etc/bash.bashrc



reboot now