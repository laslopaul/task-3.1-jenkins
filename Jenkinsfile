pipeline {
    agent any
    parameters {
        string(name: "BRANCH", defaultValue: "staging", trim: true, description: "Git branch to build")
        string(name: "DEPLOY_USER", defaultValue: "ubuntu", trim: true, description: "Username pn the deploy server")
        string(name: "DEPLOY_HOST", defaultValue: "ec2-52-207-241-186.compute-1.amazonaws.com", trim: true, description: "Address of the deployment server")
    }
    
    stages {
        stage("Cloning Git") {
            steps {
                echo "Checkout to $BRANCH"
                git([url: "https://github.com/laslopaul/task-3.1-jenkins.git", branch: params.BRANCH, credentialsId: "laslopaul-github"])
 
            }
        }
        
        stage("Build") {
            steps {
                script {
                    echo "Build stage"
                    app = docker.build("laslopaul/flask-hello")
                }
            }
        }
        
        stage("Backup") {
            steps {
                script {
                    echo "Backup stage"
                    docker.withRegistry( "", "docker-hub" ) {
                    app.push("$BUILD_NUMBER-$BRANCH")
                    if (env.BRANCH_NAME == "main") {
                        app.push('latest')
                    }
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
} 
