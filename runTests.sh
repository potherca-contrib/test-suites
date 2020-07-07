echo Testing $1...
echo Building image...
docker build -t $1 servers/$1

echo Starting server...
docker run -d --name=server --network=testnet $1
if [[ "$1" == nextcloud-server ]]
  then
    echo Waiting for Nextcloud server to start ...
    sleep 10
    docker logs server
    echo Running init script for Nextcloud server ...
    docker exec -u www-data -it server sh /init.sh
fi

echo Running webid-provider tester...
docker run --network=testnet --env-file servers/$1/env.list webid-provider 2> reports/$1-webid-provider.txt

echo Stopping server...
docker stop server

echo Removing server...
docker rm server
