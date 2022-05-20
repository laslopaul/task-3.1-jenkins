# A shell script to deploy Docker image to EC2 instance via Jenkinsfile

if [[ $1 = "staging" ]]
then
    PORT=5000
    DOCKER_TAG=$2-$1
else
    PORT=8000
    DOCKER_TAG=latest
fi

echo "Starting to deploy docker image.."
DOCKER_IMAGE=laslopaul/flask-hello
docker pull $DOCKER_IMAGE:$DOCKER_TAG
docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs -r docker stop
docker run -dp $PORT:$PORT $DOCKER_IMAGE:$DOCKER_TAG
