pipeline {
    agent any

    stages {
        stage('Configure Docker registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-ecr',
                                                  passwordVariable: 'AWS_SECRET_ACCESS_KEY',
                                                  usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh 'echo $AWS_ACCESS_KEY_ID'
                    sh 'echo $AWS_SECRET_ACCESS_KEY'
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
