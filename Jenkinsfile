def IMAGE_NAME = 'flask-page'
def IMAGE_TAG = 'latest' // Set a default

pipeline {
    agent { label 'agent1' }

    stages {
        stage('Check Branch') {
            steps {
                script {
                    sh "git fetch --tags"
                    // Try to get branch from Jenkins env or fallback to git
                    def branch = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    env.dockerTag = sh(script: "git describe --exact-match --tags ${branch} || echo ''", returnStdout: true).trim()

                    echo "Branch: '${branch}'"
                    if (branch == "main") {
                         env.dockerTag = 'latest'
                    } else if (branch == "develop") {
                        def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.dockerTag = "develop-${shortCommit}"
                    } else {
                        echo "non ci sono altre tag disponibili"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building image: ${IMAGE_NAME}:${env.dockerTag}"
                sh "docker build -t ${IMAGE_NAME}:${env.dockerTag} ."
            }
        }


        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker tag ${IMAGE_NAME}:${env.dockerTag} accountaziendale/${IMAGE_NAME}:${env.dockerTag}"
                    sh "docker push accountaziendale/${IMAGE_NAME}:${env.dockerTag}"
                    echo "hello world"
                }
            }
        }
    }
}
