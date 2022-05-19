pipeline {
    agent any
    parameters {
        string(name: "BRANCH", defaultValue: "staging", trim: true, description: "Git branch to build")
    }
    stages {
        stage('Cloning Git') {
            steps {
                git([url: 'https://github.com/laslopaul/task-3.1-jenkins.git', branch: params.BRANCH], credentialsId: 'laslopaul-github')
 
      }
    }
        stage("Build") {
            steps {
                echo "Build stage."
                app = docker.build("flask-hello")
            }
        }
        
    }
} 
