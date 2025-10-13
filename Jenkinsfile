pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DOCKER_IMAGE = 'nermineaziza03/nom_image'
        APP_VERSION = '1.0'
    }

    stages {
        // Cloner le dépôt
        stage('Cloner le dépôt') {
            steps {
                echo 'Clonage du dépôt Git...'
                checkout scm
            }
        }

        // Build avec Maven
        stage('Build Maven') {
            steps {
                echo 'Compilation du projet Java...'
                sh 'mvn clean install -DskipTests'
            }
        }

        // Exécution des tests
        stage('Exécuter les tests') {
            steps {
                echo 'Lancement des tests unitaires...'
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        // Construire l'image Docker
        stage('Construire l’image Docker') {
            steps {
                echo 'Construction de l’image Docker...'
                script {
                    def commit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    def date = sh(returnStdout: true, script: 'date +%Y%m%d').trim()
                    env.IMAGE_TAG = "${APP_VERSION}-${date}-${commit}"
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                }
            }
        }

        // =Taguer l’image
        stage('Taguer l’image Docker') {
            steps {
                echo "Tag de l’image : ${DOCKER_IMAGE}:${IMAGE_TAG} → latest"
                sh "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest"
            }
        }

        // Publier l’image sur Docker Hub
        stage('Publier sur Docker Hub') {
            steps {
                echo 'Publication de l’image sur Docker Hub...'
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline terminé avec succès !"
        }
        failure {
            echo "Le pipeline a échoué ! Vérifie les logs."
        }
    }
}
