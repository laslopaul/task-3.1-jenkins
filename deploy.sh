# A shell script to deploy Docker image to EC2 instance via Jenkinsfile

PORT=8000
DOCKER_IMAGE=laslopaul/flask-hello
DOCKER_CONTAINER=flask-hello-production
DOCKER_TAG=latest

echo "Starting to deploy docker image.."
docker pull $DOCKER_IMAGE:$DOCKER_TAG
docker ps -q --filter name=$DOCKER_CONTAINER | xargs -r docker stop
docker run --rm --name $DOCKER_CONTAINER -dp $PORT:$PORT $DOCKER_IMAGE:$DOCKER_TAG
