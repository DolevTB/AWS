pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        REPO_NAME = 'dolev-cats'
        IMAGE_TAG = 'latest'
        ACCOUNT_ID = '992382545251'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/DolevTB/AWS.git',
                                               credentialsId: '50148bd9-2bef-435f-88c6-b1dc3d09b201']]])
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-credentials-id') {
                    sh '''
                    id
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 992382545251.dkr.ecr.us-east-1.amazonaws.com                    
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    cd flask-app
                    docker build -t dolevicats .
                    docker tag dolevicats:latest 992382545251.dkr.ecr.us-east-1.amazonaws.com/dolevicats:latest
                '''
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh 'docker push 992382545251.dkr.ecr.us-east-1.amazonaws.com/dolevicats:latest'
            }
        }
        stage('Deploy container') {
            steps {
                sh 'docker run -d -p 8080:8080 -p 5000:5000 dolevicats:latest'
            }
        }
    }
    post { 
        always { 
            echo " removing container "
            sh 'docker image prune -af'
        }
    }
}
