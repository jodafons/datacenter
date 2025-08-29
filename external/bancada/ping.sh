export ANSIBLE_HOST_KEY_CHECKING=False

ansible bancada -m ping -v -i hosts
