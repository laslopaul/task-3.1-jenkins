# A shell script to deploy Docker image to EC2 instance via Jenkinsfile

if [[ $1 = "staging" ]]
then
    PORT=5000
else
    PORT=8000
fi

echo "Starting to deploy docker image.."
DOCKER_IMAGE=laslopaul/flask-hello
docker pull $DOCKER_IMAGE
docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs -r docker stop
docker run -dp $PORT:$PORT $DOCKER_IMAGE
