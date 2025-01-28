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
                        aws ecr-public get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin public.ecr.aws/c0m6s3p2
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    cd flask-app
                    sudo docker build -t dolev-cats .
                    sleep(10)
                    sudo docker tag dolev-cats:latest public.ecr.aws/c0m6s3p2/dolev-cats:latest
                '''
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh 'sudo docker push public.ecr.aws/c0m6s3p2/dolev-cats:latest'
            }
        }
    }
}
