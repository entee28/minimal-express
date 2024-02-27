pipeline {
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
                      command:
                      - /busybox/cat
                      tty: true
                      volumeMounts:
                      - name: docker-config
                        mountPath: /kaniko/.docker/
                      - name: kaniko-secret
                        mountPath: /kaniko/.docker/acr/
                    restartPolicy: Never
                    volumes:
                    - name: docker-config
                      configMap:
                        name: docker-config
                    - name: kaniko-secret
                      secret:
                        secretName: kaniko-secret
            '''
        }
    }

    stages {
        stage('Build Docker Image with Kaniko') {
            environment {
                PATH = "/busybox:/kaniko:$PATH"
            }

            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh '''#!/busybox/sh
                        /kaniko/executor --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
