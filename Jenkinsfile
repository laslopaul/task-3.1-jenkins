pipeline {
    agent any
    parameters {
        string(name: "BRANCH", defaultValue: "staging", trim: true, description: "Git branch to build")
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
        
    }
} 
