pipeline {
    stages {
        stage('Cache stage') {
            agent any
            steps {
                cache(maxCacheSize: 250, defaultBranch: 'main', caches: [
                    arbitaryFileCache(
                        path: 'node_modules',
                        cacheValidityDecidingFile: 'package-lock.json'
                    )
                ]) {
                    sh 'npm ci'
                }
            }
        }

        stage('Build Docker Image with Kaniko') {
            agent {
                kubernetes {
                    yaml '''
                        kind: Pod
                        metadata:
                            name: kaniko
                        spec:
                            containers:
                            - name: jnlp
                            workingDir: /home/jenkins
                            - name: kaniko
                            workingDir: /home/jenkins
                            image: gcr.io/kaniko-project/executor:debug
                            envFrom:
                                - secretRef:
                                    name: kaniko-secret
                            command:
                            - /busybox/cat
                            tty: true
                            volumeMounts:
                            - name: docker-config
                                mountPath: /kaniko/.docker/
                            - name: lib-cache
                                mountPath: /home/node/app/node_modules
                            restartPolicy: Never
                            volumes:
                            - name: docker-config
                            configMap:
                                name: docker-config
                            - name: lib-cache
                            persistentVolumeClaim:
                                claimName: my-azurefile
                    '''
                }
            }

            environment {
                PATH = "/busybox:/kaniko:$PATH"
                CI_PROJECT_DIR = "${env.WORKSPACE}"
            }

            steps {
                cache(maxCacheSize: 250, defaultBranch: 'main', caches: [
                    arbitaryFileCache(
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
                        --dockerfile ${CI_PROJECT_DIR/Dockerfile \
                        --verbosity debug \
                        --destination thachthucregistry.azurecr.io/minimal-express:latest \
                    '''
                        }
                    }
                }
            }
        }
    }
