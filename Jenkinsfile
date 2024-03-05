pipeline {
    agent none

    stages {
        stage('Cache stage') {
            agent any

            steps {
                cache(maxCacheSize: 250, defaultBranch: 'main', caches: [
                    arbitraryFileCache(
                        path: 'node_modules',
                        cacheValidityDecidingFile: 'package-lock.json'
                    )
                ]) {
                    nodejs(nodeJSInstallationName: 'node') {
                        sh 'npm ci'
                    }
                }
            }
        }

        stage('Build Docker Image with Kaniko') {
            agent {
                kubernetes {
                    defaultContainer 'kaniko'
                    yamlFile 'k8s/kaniko.yaml'
                }
            }

            environment {
                PATH = "/busybox:/kaniko:$PATH"
                CI_PROJECT_DIR = "${env.WORKSPACE}"
            }

            steps {
                sh '''#!/busybox/sh
                    /kaniko/executor \
                    --cache=true \
                    --use-new-run \
                    --snapshot-mode=redo \
                    --context $CI_PROJECT_DIR \
                    --dockerfile $CI_PROJECT_DIR/Dockerfile \
                    --verbosity debug \
                    --build-arg CI_PROJECT_DIR=$CI_PROJECT_DIR \
                    --destination thachthucregistry.azurecr.io/minimal-express:latest \
                '''
            }
        }
    }
}
