pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/integrating-security-scanning'
        DOCKER_TAG = 'latest'
        SONARQUBE_SCANNER_HOME = tool 'SonarQubeScanner'
        GITHUB_REPO = 'https://github.com/ShandoshAathi/Athi---sonarqube-and-Trivy.git'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: env.GITHUB_REPO
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    ${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=integrating-security-scanning \
                    -Dsonar.projectName="Integrating automated security scanning into DevOps pipelines" \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://your-sonarqube-server:9000 \
                    -Dsonar.login=your-Sonarqube-token
                    '''
                }
            }
        }
        
        stage('Trivy Vulnerability Scan') {
            steps {
                sh 'trivy fs --security-checks vuln,config .'
                sh 'trivy image --severity CRITICAL ${DOCKER_IMAGE}:${DOCKER_TAG}'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        docker.image("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Production') {
            steps {
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            slackSend(color: 'good', message: "Build Successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}")
        }
        failure {
            slackSend(color: 'danger', message: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}")
        }
    }
}
