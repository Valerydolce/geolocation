pipeline {
    agent any
    tools{
        maven 'MAVEN HOME'
    }

    environment {
        registry = '454292818931.dkr.ecr.us-west-1.amazonaws.com/geolocation_ecr_rep'
        registryCredential = 'jenkins-ecr'
        dockerimage = ''
  }
  
    stages {
        stage('Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/Valerydolce/geolocation.git'
            }
        }
        stage('Code Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        // Building Docker images
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry
                }
            }
        }
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps{
                script {
                    sh 'aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 454292818931.dkr.ecr.us-west-1.amazonaws.com/geolocation_ecr_rep'
                    sh 'docker push 454292818931.dkr.ecr.us-west-1.amazonaws.com/geolocation_ecr_rep:latest'
                }
            }
        }
        //deploy the image that is in ECR to our EKS cluster
        stage ("Kube Deploy") {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'eks_credential', namespace: '', serverUrl: '') {
                 sh "kubectl apply -f eks_deploy_from_ecr.yml"
                }
            }
            //deploy role and role binding 
        stage ("Kube deploy - Permission") {
            steps {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'eks_credential', namespace: '', serverUrl: '') {
                 sh "kubectl apply -f eks-console-full-access.yaml"
                }
            }            

        }
            
        }
    }
}