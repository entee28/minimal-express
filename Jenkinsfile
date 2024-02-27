pipeline {
    agent any

    environment {
    }

    stages {
        stage('Build Docker Image with Kaniko') {
            steps {
                container(name: 'kaniko') {
                    sh '''
                        /kaniko/executor --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
