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
                      envFrom:
                        - secretRef:
                            name: kaniko-secret
                      command:
                      - /busybox/cat
                      tty: true
                      volumeMounts:
                      - name: docker-config
                        mountPath: /kaniko/.docker/
                    restartPolicy: Never
                    volumes:
                    - name: docker-config
                      configMap:
                        name: docker-config
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
                        echo $AZURE_CLIENT_ID
                        /kaniko/executor --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
