pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        REPO_NAME = 'dolev-cats' // Public ECR repository name
        IMAGE_TAG = 'latest'     // Always using the 'latest' tag
        ACCOUNT_ID = '992382545251'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']], 
                          userRemoteConfigs: [[url: 'https://github.com/DolevTB/AWS.git']]])
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AKIA6ODU35VRUWLVT3O2']]) {
                    sh """
                    aws ecr-public get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin public.ecr.aws/${ACCOUNT_ID}/${REPO_NAME}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    sh "docker tag ${REPO_NAME}:${IMAGE_TAG} public.ecr.aws/${ACCOUNT_ID}/${REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh "docker push public.ecr.aws/${ACCOUNT_ID}/${REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
