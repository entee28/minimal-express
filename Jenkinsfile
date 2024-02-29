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
                        docker run -v $(pwd):/workspace gcr.io/kaniko-project/warmer:latest --cache-dir=/kaniko/cache --dockerfile='/kaniko/Dockerfile'
                        /kaniko/executor --context '.' --cache=true --cache-dir='/kaniko/cache' --cache-copy-layers --cache-run-layers --dockerfile Dockerfile --verbosity debug --destination thachthucregistry.azurecr.io/minimal-express:latest
                    '''
                }
            }
        }
    }
}
