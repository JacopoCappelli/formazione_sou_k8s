pipeline {
    agent { label 'agent1' }

    environment {
        IMAGE_NAME = 'flask-page'
        IMAGE_TAG = ''
    }

    stages {

        stage('Check Branch') {
            steps {
                script {
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Branch: ${branch}"

                    if (branch == "main") {
                        env.IMAGE_TAG = "latest"
                    } else if (branch == "develop") {
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.IMAGE_TAG = "develop-${sha}"
                    } else {
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.IMAGE_TAG = "${branch}-${sha}"
                    }

                    echo "Docker Tag from branch: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Check Git Tag') {
            steps {
                script {
                    def tag = sh(script: "git tag --points-at HEAD", returnStdout: true).trim()
                    if (tag) {
                        env.IMAGE_TAG = tag
                        echo "Found Git tag: ${tag}"
                    } else {
                        echo "No Git tag found on this commit."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                sh "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing image: accountaziendale/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                sh "docker tag ${env.IMAGE_NAME}:${env.IMAGE_TAG} accountaziendale/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                sh "docker push accountaziendale/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
            }
        }
    }
}
