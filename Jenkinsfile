node {
    checkout scm

    stage('Configure Docker registry') {
        withCredentials([usernamePassword(credentialsId: 'aws-ecr',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID')]) {

            env.REPO_NAME = repoName {}

            sh '''
            aws configure set default.region eu-west-1
            aws configure set aws_access_key_id $AWS_SECRET_ACCESS_KEY
            aws configure set aws_secret_access_key $AWS_ACCESS_KEY_ID

            if ! aws ecr describe-repositories --repository-names ${env.REPO_NAME} > /dev/null 2>&1; then
                aws ecr create-repository --repository-name ${env.REPO_NAME};
            fi
            '''
        }
    }
    stage('Build') {
        echo 'Building..'
    }
    stage('Deploy') {
        echo 'Deploying....'
    }
}

@NonCPS
def repoName() {
    sh(
        script: 'basename `git rev-parse --show-toplevel`',
        returnStdout: true
    ).trim()
}
