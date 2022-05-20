# A shell script to deploy Docker image to EC2 instance via Jenkinsfile

PORT=5000
DOCKER_IMAGE=laslopaul/flask-hello
DOCKER_TAG=$1-staging

echo "Starting to deploy docker image.."
docker pull $DOCKER_IMAGE:$DOCKER_TAG
docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs -r docker stop
docker run -dp $PORT:$PORT $DOCKER_IMAGE:$DOCKER_TAG
