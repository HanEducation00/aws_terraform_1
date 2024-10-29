### Jenkinsfile

```
pipeline {
    agent any
    
    environment {
        APP_NAME = "github_aws_1"
        RELEASE = "1.0"
        DOCKER_USER = "hanoguz00"
        DOCKER_LOGIN = "dockerhub"
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}.${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/HanEducation00/aws_terraform_1'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                    '''
                }
            }
        }

        stage('Build & Push Docker Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        docker_image = docker.build("${IMAGE_NAME}")
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push("latest")
                    }
                }
            }
        }

        stage("Trivy Scan for Vulnerabilities") {
            steps {
                script {
                    sh '''
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image ${IMAGE_NAME}:${IMAGE_TAG} --no-progress \
                    --scanners vuln --exit-code 0 --severity HIGH,CRITICAL --format table
                    '''
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

### Jenkinsfile 2

