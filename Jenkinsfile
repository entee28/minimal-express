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
                      - name: docker-cache
                        mountPath: /kaniko/cache/
                    restartPolicy: Never
                    volumes:
                    - name: docker-config
                      configMap:
                        name: docker-config
                    - name: docker-cache
                      persistentVolumeClaim:
                        claimName: my-azurefile 
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
                        /kaniko/executor --context '.' --cache=true --cache-dir='/cache' --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
