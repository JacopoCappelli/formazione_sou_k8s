def IMAGE_NAME = 'flask-page'
def IMAGE_TAG = ''

pipeline {
    agent { label 'agent1' }

    environment {
        IMAGE_NAME = "${IMAGE_NAME}"
    }

    stages {
        stage('Check Branch') {
            steps {
                script {
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true)
                    echo "Branch: ${branch}"

                    if (branch == "main") {
                        IMAGE_TAG = "latest"
                    }  
                    if (branch == "develop") {
                        def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true)
                        IMAGE_TAG = "develop-${shortCommit}"
                    } 

                    env.IMAGE_TAG = IMAGE_TAG
                    echo "Docker tag set to: ${IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} accountaziendale/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push accountaziendale/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
