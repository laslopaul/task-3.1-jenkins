pipeline {
    agent any
    environment {
        BRANCH_NAME = "staging"
        DOCKER_IMAGE = "laslopaul/flask-hello"
    }
    
    options { 
        buildDiscarder(logRotator(numToKeepStr: '5')) 
    }

    parameters {
        string(name: "DEPLOY_USER", defaultValue: "ubuntu", trim: true, description: "Username on the deployment server")
        string(name: "DEPLOY_HOST", defaultValue: "ec2-54-242-249-97.compute-1.amazonaws.com", trim: true, description: "Address of the deployment server")
    }
    
    triggers {
        GenericTrigger(
         genericVariables: [
          [key: "ref", value: '$.ref']
         ],

         causeString: "Triggered on push $ref",

         token: '262e2aefce1765eea88053b7ea6ce5800d3a7c06',
         tokenCredentialId: 'webhook-trigger',

         printContributedVariables: false,
         printPostContent: true,

         silentResponse: false,

         regexpFilterText: '$ref',
         regexpFilterExpression: 'refs/heads/' + env.BRANCH_NAME
        )
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
                        ssh ${DEPLOY_USER}@${DEPLOY_HOST} ./deploy.sh $BUILD_NUMBER
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
