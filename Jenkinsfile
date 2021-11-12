pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "spring-petclinic"
        TERRAFORM_HOME = "./terraform"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
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
                    docker.withRegistry('https://public.ecr.aws/x0x5b9b9/spring-petclinic-repo', 'ecr_credentials') {
                            app.push("${env.BUILD_NUMBER}")
                            app.push("latest")
                        }
                }
            }
        }
        stage('DEPLOY') {
            steps {
                echo 'Running DEPLOY'
                input 'Deploy to Production?'
                milestone(1)
                dir("terraform") {
                    sh "terraform init -input=false"
                    sh "terraform plan -out=tfplan -input=false"
                    sh "terraform apply -input=false tfplan"
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'tfplan'
        }
    }
}