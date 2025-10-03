
# Get the last part of the current working directory
current_dir="${PWD##*/}"

# Check if the current directory is named 'scripts'
if [ "$current_dir" != "scripts" ]; then
    echo "Error: This script must be run from the 'scripts' directory."
    exit 1
fi

sudo kdb5_util dump -verbose lps.ufrj.br.krb5

sudo chgrp cluster lps.ufrj.br.krb5
sudo chown cluster lps.ufrj.br.krb5
sudo rm lps.ufrj.br.krb5.dump_ok


sudo cp lps.ufrj.br.krb5 /mnt/market_place/data
mv lps.ufrj.br.krb5 ../files/data