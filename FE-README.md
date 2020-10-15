# Install React app

## update node
```
sudo apt update
sudo apt install build-essential checkinstall libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.1/install.sh | bash
```
- restart the terminal
- install nvm
```
nvm install 10
```

## setup yarn
```
sudo apt remove cmdtest
sudo apt remove yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn
```
put this in path as well
```
export PATH="$PATH:$(yarn global bin)"
```

## setup env
- copy build folder to server
- install server
```
yarn global add serve
```
- run server (default listen on 3100)
```
serve -s build -l 3100 -C
```
