def IMAGE_NAME = 'flask-page'
def IMAGE_TAG = ' '


pipeline {

    agent { label 'agent1' }

   
    

    stages {
        stage('Check Branch') {
            steps {
                script {
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD")
                    echo "Branch: ${branch}"

                    if (branch == "main") {
                        env.IMAGE_TAG = "latest"
                    }  
                    if (branch == "develop") {
                        def sha = sh(script: "12")
                        env.IMAGE_TAG = "develop-${sha}"
                    } 

                    echo "Branch: ${branch}"
                    echo "Docker Tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('check git tag'){

            steps {
                script {
                    try {
                        def gitTag = sh(script: "git tag")
                        if (gitTag) {
                            env.IMAGE_TAG = gitTag
                            echo "Found Git tag: ${gitTag}"
                        } else {
                            echo "No tag found on this commit."
                        }
                    } catch (err) {
                        echo "Error running git describe: ${err}"
                        env.IMAGE_TAG = ''
                    }
                }
            }

        }

        stage('Build') {
            steps {
                sh "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
            }
        }

        stage('Push') {
            steps {
                sh "docker push accountaziendale/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
            }
        }
    }
}
