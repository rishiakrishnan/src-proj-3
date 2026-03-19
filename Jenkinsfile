pipeline {
    agent any

    environment {
        IMAGE_NAME = "react-app"
    }

    stages {

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to development') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag $IMAGE_NAME $DOCKER_USER/devapp-dev:latest
                    docker push $DOCKER_USER/devapp-dev:latest
                    '''
                }
            }
        }

        stage('Push to production') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag $IMAGE_NAME $DOCKER_USER/devapp-devapp-prod:latest
                    docker push $DOCKER_USER/devapp-devapp-prod:latest
                    '''
                }
            }
        }

        stage('Deploy to production servers') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sshagent(['ec2-ssh']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@44.200.17.163 "
                        
                        docker pull ${DOCKER_USER}/devapp-devapp-prod:latest
                        
                        docker stop react-container || true
                        docker rm react-container || true
                        
                        docker run -d -p 80:80 --name react-container ${DOCKER_USER}/devapp-devapp-prod:latest
                        "
                        """
                    }
                }
            }
        }
    }
}
# Note: Replace <username> with your actual Docker Hub username in the above script.