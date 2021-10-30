pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "antonzabolotnyi/spring-petclinic"
    }
    stages {
        stage('BUILD') {
            steps {
                echo 'Running BUILD'
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }
        stage('CREATE ARTIFACT') {
            steps {
                echo 'Running CREATE ARTIFACT'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                            app.push("${env.BUILD_NUMBER}")
                            app.push("latest")
                        }
                }
            }
        }
        stage('DEPLOY') {
            steps {
                echo 'Running DEPLOY'
            }
            build job: 'spring-petclinic-deploy', 
                parameters: [
                    choice(name: 'HOSTS', value: String.valueOf(ENVIRONMENT)),
                    choice(name: 'ROLES', value: String.valueOf(TASK)),
                    string(name: 'CONTAINER_VERSION', value: String.valueOf(CONTAINER_VERSION))

                ]
        }
    }
}