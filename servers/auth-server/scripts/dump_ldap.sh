# Get the last part of the current working directory
current_dir="${PWD##*/}"

# Check if the current directory is named 'scripts'
if [ "$current_dir" != "scripts" ]; then
    echo "Error: This script must be run from the 'scripts' directory."
    exit 1
fi

sudo slapcat -b cn=config > config.ldif
sudo slapcat -b dc=lps,dc=ufrj,dc=br > lps.ufrj.br.ldif


sudo cp lps.ufrj.br.ldif /mnt/market_place/data
sudo cp config.ldif /mnt/market_place/data
mv lps.ufrj.br.ldif ../files/data
mv config.ldif ../files/data
