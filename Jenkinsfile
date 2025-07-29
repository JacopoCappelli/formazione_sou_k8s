def IMAGE_NAME = 'flask-page'

pipeline {
    agent { label 'agent1' }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Tag image') {
            steps {
                script {
                    sh "git fetch --tags"

                   
                    def branch = env.BRANCH_NAME ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    env.GIT_BRANCH = "origin/${branch}"
                    env.GIT_COMMIT = sh(script: "git rev-parse HEAD", returnStdout: true).trim()

                    env.dockerTag = 'idk'  

                    echo "GIT_BRANCH: ${env.GIT_BRANCH}"
                    echo "GIT_COMMIT: ${env.GIT_COMMIT}"

                    if (env.GIT_BRANCH.startsWith('origin/main/tags/')) {
                        env.dockerTag = env.GIT_BRANCH.replace('origin/main/tags/', '')
                    } else if (env.GIT_BRANCH == 'origin/main') {
                        env.dockerTag = 'latest'
                    } else if (env.GIT_BRANCH == 'origin/develop') {
                        env.dockerTag = "develop-${env.GIT_COMMIT.substring(0, 7)}"
                    } else {
                        env.dockerTag = "${branch}-${env.GIT_COMMIT.substring(0, 7)}"
                    }

                    echo "FINAL DOCKER TAG: ${env.dockerTag}"
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
                    
                }
            }
        }
        
    }
    
}
