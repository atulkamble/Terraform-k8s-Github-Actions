pipeline {
    agent any

    environment {
        KUBECONFIG = "/home/ec2-user/.kube/config"
        FRONTEND_IMAGE = "samikshav/full-stack-app-frontend:latest"
        BACKEND_IMAGE  = "samikshav/full-stack-app-backend:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Samiksha998/project.git', branch: 'main'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh '''
                    # Assumes `docker login` already done manually on the Jenkins host

                    cd docker/frontend
                    echo 'admin' | sudo -S docker build -t $FRONTEND_IMAGE .
                    echo 'admin' | sudo -S docker push $FRONTEND_IMAGE
                    cd ../..

                    cd docker/backend
                    echo 'admin' | sudo -S docker build -t $BACKEND_IMAGE .
                    echo 'admin' | sudo -S docker push $BACKEND_IMAGE
                    cd ../..
                    '''
                }
            }
        }


    }

    post {
        always {
            echo "✅ Pipeline completed."
        }
    }
}
