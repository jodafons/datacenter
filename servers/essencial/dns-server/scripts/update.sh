
# Get the last part of the current working directory
current_dir="${PWD##*/}"
# Check if the current directory is named 'scripts'
if [ "$current_dir" != "scripts" ]; then
    echo "Error: This script must be run from the 'scripts' directory."
    exit 1
fi

cp -r ../files/bind/* /etc/bind
systemctl restart bind9
named-checkconf
named-checkzone lps.ufrj.br /etc/bind/zones/db.lps.ufrj.br
named-checkzone 1.1.10.in-addr.arpa /etc/bind/zones/db.1.1.10
named-checkzone 147.164.146.in-addr.arpa /etc/bind/zones/db.147.164.146
