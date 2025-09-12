pipeline {
    agent any

    stages {
        stage("Clone Code") {
            steps {
                git url: "https://github.com/On-cloud7/ems.git", branch: "main"
                echo "Code cloned successfully"
            }
        }

        stage("Build & Test") {
            steps {
                sh "docker build . -t  app:latest"
                echo "Docker image built"
            }
        }

        stage('Push to DockerHub') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'dockerCreds', 
                                          usernameVariable: 'dockerHubUser', 
                                          passwordVariable: 'dockerHubPass')]) {
            sh '''
            echo "Logging in to DockerHub..."
            echo "$dockerHubPass" | docker login -u "$dockerHubUser" --password-stdin

            echo "Tagging image..."
            docker tag app:latest $dockerHubUser/app:latest

            echo "Pushing image..."
            docker push $dockerHubUser/app:latest
            '''
        }
    }
}


        stage("Deploy") {
            steps {
                sh '''
                    echo " Starting Docker Compose"
                    docker compose up -d
                '''
            }
        }
    }
}
