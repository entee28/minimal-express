pipeline {
    agent any

    environment {
        AZ_SERVICE_PRINCIPLE = credentials('azcred')
        AZ_SUBSCRIPTION_ID = '32a52723-1a68-42d9-871f-e7834f51dbfd'
        AZ_TENANT_ID = 'a3ff8926-c642-4722-85a2-246eb3098a3c'
    }

    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'zip -r dist.zip .'
                stash includes: '**/*.zip', name: 'app'
            }
        }

        stage("Deploy") {
            steps {
                unstash 'app'
                sh '''
                    az login --service-principal -u $AZ_SERVICE_PRINCIPLE_USR -p $AZ_SERVICE_PRINCIPLE_PSW -t $AZ_TENANT_ID
                    az account set -s $AZ_SUBSCRIPTION_ID
                '''
                sh 'az webapp deployment source config-zip --resource-group jenkins-lab --name minimal-express --src dist.zip'
            }
        }
    }
}