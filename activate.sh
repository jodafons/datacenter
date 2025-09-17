
export VIRTUALENV_NAMESPACE='datacenter-env'
export LOGURU_LEVEL="DEBUG"
export VIRTUALENV_PATH=$PWD/$VIRTUALENV_NAMESPACE
export DATACENTER_DATA_PATH=$PWD/data
export CLUSTER_MASTER_KEY=$CLUSTER_ADMIN_MASTER_KEY
export ANSIBLE_PASSWORD=$CLUSTER_MASTER_KEY

if [ -d "$VIRTUALENV_PATH" ]; then
    echo "$VIRTUALENV_PATH exists."
    source $VIRTUALENV_PATH/bin/activate
    export PYTHONPATH=$PYTHONPATH:$PWD

else
    virtualenv -p python ${VIRTUALENV_PATH}
    source $VIRTUALENV_PATH/bin/activate
    pip install -e .
    export PYTHONPATH=$PYTHONPATH:$PWD
fi