pipeline {
    agent any
    environment {
        BRANCH_NAME = "main"
        DOCKER_IMAGE = "laslopaul/flask-hello"
    }
    
    options { 
        buildDiscarder(logRotator(numToKeepStr: '5')) 
    }

    parameters {
        string(name: "DEPLOY_USER", defaultValue: "ubuntu", trim: true, description: "Username on the deployment server")
        string(name: "DEPLOY_HOST", defaultValue: "ec2-18-234-211-241.compute-1.amazonaws.com", trim: true, description: "Address of the deployment server")
    }
    
    stages {
        stage("Cloning Git") {
            steps {
                echo "Checkout to ${BRANCH_NAME}"
                git([url: "https://github.com/laslopaul/task-3.1-jenkins.git", branch: env.BRANCH_NAME, credentialsId: "laslopaul-github"])
 
            }
        }
        
        stage("Build") {
            steps {
                script {
                    echo "Build stage"
                    app = docker.build(env.DOCKER_IMAGE)
                }
            }
        }
        
        stage("Backup") {
            steps {
                script {
                    echo "Backup stage"
                    docker.withRegistry( "", "docker-hub" ) {
                    app.push("$BUILD_NUMBER-$BRANCH_NAME")
                    app.push("latest")
          }
        }
      }
    }
    
        stage ("Deploy") {
            steps {
                echo "Deploy stage"
                sshagent(credentials : ["keypair-ec2"]) {
                    sh '''
                        [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                        ssh-keyscan -t rsa,dsa ${DEPLOY_HOST} >> ~/.ssh/known_hosts
                        scp deploy.sh ${DEPLOY_USER}@${DEPLOY_HOST}:~/
                        ssh ${DEPLOY_USER}@${DEPLOY_HOST} ./deploy.sh
                    '''
                }
        }
    }
    }
    
    post {
        success {
            echo "Remove unused local Docker image"
            sh "docker rmi $DOCKER_IMAGE:$BUILD_NUMBER-$BRANCH_NAME"
        }
    }
} 
