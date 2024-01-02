pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'

    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        APP_NAME = "reddit-clone-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "hemasivakishore"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
    stages {
        stage ('clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage ('Checkout from GIT') {
            steps {
                git branch: 'main', url: 'https://github.com/Ashfaque-9x/a-reddit-clone.git'
            }
        }
        stage ('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Scanner') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Reddit-Clone-CI \
                    -Dsonar.projectKey=Reddit-Clone-CI'''
                }
                // withSonarQubeEnv(credentialsId: 'SonarQube-Token') {
                //     sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Reddit-Clone-CI \
                //     -Dsonar.projectKey=Reddit-Clone-CI'''
                // }
            }
        }
        stage ('QualityGate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token'
                }
            }
        }
        stage ('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage ('Trivy FS Scan') {
            steps {
                sh "trivy fs .> trivyfs.txt"
            }
        }
        // stage ('Docker Push') {
        //     steps {
        //         script {
        //             docker.withRegistry('',DOCKER_PASS) {
        //                 docekr_image = docker.build "${IMAGE_NAME}"
        //             }

        //             docker.withRegistry('',DOCKER_PASS) {
        //                 docker_image.push("${IMAGE_TAG}")
        //                 docker_image.push('latest')
        //             }
        //         }
        //     }
        // }
        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
             }
         }
        stage ('Trivy Image Scane') {
            steps {
                script {
                    sh ('')
                }
            }
        }
        stage ('CleanUp Artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
            }
        }
    }
}