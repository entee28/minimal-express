pipeline {
    agent any

    stages {
        stage('Cache stage') {
            steps {
                podTemplate {
                    node(POD_LABEL) {
                        stage('Cache') {
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
                }
            }
        }

        stage('Build Docker Image with Kaniko') {
            environment {
                PATH = "/busybox:/kaniko:$PATH"
                CI_PROJECT_DIR = "${env.WORKSPACE}"
            }

            steps {
                podTemplate(yaml: readTrusted('k8s/kaniko.yaml')) {
                    node(POD_LABEL) {
                        stage('Build') {
                            cache(maxCacheSize: 250, defaultBranch: 'main', caches: [
                                arbitraryFileCache(
                                    path: 'node_modules',
                                    cacheValidityDecidingFile: 'package-lock.json'
                                )
                            ]) {
                                container(name: 'kaniko', shell: '/busybox/sh') {
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
                }
            }
        }
    }
}
