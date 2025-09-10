
# Github Runner


Setup all network configurations:

```
source setup_network.sh
```

Install all packages:

```
source install_base.sh
```


## Install GitHub Runner:

```
mkdir actions-runner && cd actions-runner
```

Download the runner from the server

```
curl -o actions-runner-linux-x64-2.300.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.300.2/actions-runner-linux-x64-2.300.2.tar.gz
```

Extract the installer:

```
tar xzf ./actions-runner-linux-x64-2.300.2.tar.gz
```

Configure the runner and start the configuration experience

```
./config.sh --url https://github.com/lorenzetti-hep/lorenzetti --token $TOKEN_FROM_GITHUB_ACTION_PAGE
./run.sh
```

### Setup as a service:

Stop the self-hosted runner application if it is currently running.

```
sudo ./svc.sh install
```
Start the service with the following command:

```
sudo ./svc.sh start
```

Check the status of the service with the following command:

```
sudo ./svc.sh status
```

### Using your self-hosted runner

Use this YAML in your workflow file for each job
```
runs-on: self-hosted
```


