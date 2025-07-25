def IMAGE_NAME = 'flask-page'
def IMAGE_TAG = 'latest' // Set a default

pipeline {
    agent { label 'agent1' }

    stages {
        stage('Check Branch') {
            steps {
                script {
                    // Try to get branch from Jenkins env or fallback to git
                    def branch = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Branch: '${branch}'"
                    if (branch == "main") {
                        IMAGE_TAG = "latest"
                        pwd
                    } else if (branch == "develop") {
                        def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        IMAGE_TAG = "develop-${shortCommit}"
                        sh 'pwd'
                    } else {
                        IMAGE_TAG = branch
                    }
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
                    echo "hello world"
                }
            }
        }
    }
}
