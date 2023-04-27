pipeline {
  agent {
    docker {
      image 'maven:3.6.3-openjdk-17
      registryUrl 'https://registry.hub.docker.com'
      registryCredentialsId 'docker-cred'
      args '-v ${HOME}/.m2:/root/.m2'
   }
}
   parameters {
        string(name: 'DOCKER_IMAGE_NAME', defaultValue: "my-image:${env.BUILD_NUMBER}", description: 'Name of the Docker image to build and push')
    }
  
   stages {
    stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/pnucmcs/demojavagitrepo.git']]])
            }
        }
     stage('Build') {
            steps {
                bat 'mvn clean package'
                bat "docker build -t ${params.DOCKER_IMAGE_NAME} ."
            }
        }
      stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'your-docker-hub-credentials', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                    bat "docker login -u $pn02cidocker -p $Sadanandam9!"
                }
                bat "docker push ${params.DOCKER_IMAGE_NAME}"
            }
        }
  }
}
