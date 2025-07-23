pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t flask-page:latest .'
            }
        }
        stage('Push') {
            steps {
                sh 'docker push accountaziendale/flask-page:latest'
            }
        }
    }
}
