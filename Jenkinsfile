node {
    checkout scm

    env.REPO_NAME = sh(
        script: "echo $env.JOB_NAME | cut -f 2 -d /",
        returnStdout: true
    ).trim()

    env.DOCKER_TAG = sh(
        script: "git rev-parse HEAD | cut -c1-8",
        returnStdout: true
    ).trim()

    env.DOCKER_REGISTRY = "593291632749.dkr.ecr.eu-west-1.amazonaws.com"

    stage('Configure Docker registry') {
        withCredentials([usernamePassword(credentialsId: 'aws-ecr',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            sh """
            aws configure set default.region eu-west-1
            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

            if ! aws ecr describe-repositories --repository-names ${env.REPO_NAME} > /dev/null 2>&1; then
                aws ecr create-repository --repository-name ${env.REPO_NAME};
            fi
            """
        }
    }

    stage('Docker build') {
        sh """
        docker build \
            -t ${env.DOCKER_REGISTRY}/${env.REPO_NAME}:${env.DOCKER_TAG} \
            -t ${env.DOCKER_REGISTRY}/${env.REPO_NAME}:latest \
            .
        """
    }

    stage('Docker push') {
        sh "\$(aws ecr get-login)"
        sh "docker push ${env.DOCKER_REGISTRY}/${env.REPO_NAME}:${env.DOCKER_TAG}"
        sh "docker push ${env.DOCKER_REGISTRY}/${env.REPO_NAME}:latest"
    }

    stage('Checkout Helm charts') {
        dir('analytics-platform-ops') {
            git url: 'https://github.com/ministryofjustice/analytics-platform-ops.git'
        }
    }

    stage('Init Helm client') {
        sh "helm init -c"
    }

    stage('Deploy application') {
        sh """
        helm upgrade -i \
            ${env.REPO_NAME} \
            analytics-platform-ops/charts/shiny-app \
            --namespace apps-prod \
            --set app.name=${env.REPO_NAME} \
            --set app.baseHost=${env.APP_BASE_DOMAIN} \
            --set shinyApp.docker.repository=${env.DOCKER_REGISTRY}/${env.REPO_NAME} \
            --set shinyApp.docker.tag=${env.DOCKER_TAG} \
            --wait
        """
    }
}

