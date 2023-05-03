pipeline {
  agent {
    docker {
      image 'pnucmcs/myimage:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
      //args '-i --entrypoint=/test-docker'
    }
  }
  stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
        //git branch: 'main', url: 'https://github.com/pnucmcs/demojavagitrepo.git'
      }
    }
    stage('Build and Test') {
      steps {
        // build the project and create a JAR file
        sh 'mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://34.170.31.116:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "pnucmcs/ultimate-cicd:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }
    stage('Update file in Git repository') {
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          sh '''
          git config --global user.email "pnucmcs@gmail.com"
          git config --global user.name "pnucmcs"
          git clone https://github.com/pnucmcs/demojavagitrepo.git
          cd demojavagitrepo
          BUILD_NUMBER=${BUILD_NUMBER}
          sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" demok8.yaml
          git add demok8.yaml
          git commit -m "Update demok8.yaml"
          git push https://${GITHUB_TOKEN}@github.com/pnucmcs/demojavagitrepo main
          '''
        }
      }
    }
  }
}

