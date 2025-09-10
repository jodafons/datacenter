

docker-compose -f files/docker-compose.yaml run --rm openvpn ovpn_genconfig -u udp://146.164.147.6:3000
docker-compose -f files/docker-compose.yaml run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): $HOME/openvpn-data
docker-compose -f files/docker-compose.yaml up -d openvpn
