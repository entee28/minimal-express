pipeline {
    agent any

    environment {
        PATH = "/busybox:/kaniko:$PATH"
    }

    stages {
        stage('Build Docker Image with Kaniko') {
            steps {
                container(name: 'kaniko', shell: 'busybox/sh') {
                    sh '''#!/busybox/sh
                        /kaniko/executor --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
