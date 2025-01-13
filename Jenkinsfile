pipeline {
  agent any
  environment {
      GIT_REPO_URL = 'https://github.com/kkpdealwis/Capstone-Project-Edureka-PGD.git'
      IMAGE_NAME = 'xyz-repo-application'
      ANSIBLE_VAULT_PASSWORD = credentials('ANSIBLE_VAULT_PASSWORD')
  }
  tools {
    ansible 'ansible-2.18.1'
    maven 'maven-3.9.9'
  }
  
  stages {
    stage('clone repository') {
        steps {
            script {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/kkpdealwis/Capstone-Project-Edureka-PGD.git',
                    ]]
                ])
            }
        }
    }
    stage('check ansible') {
        steps {
            script {
              sh 'ansible --version'
            }
        }
    }
    stage('check maven') {
        steps {
            script {
                sh 'mvn --version'
            }
        }
    }
    stage('build maven project artifact') {
        steps {
            script{
                sh 'mvn clean install'
            }
        }
    }
    stage('run maven project tests') {
        steps {
            script {
                sh 'mvn test'
            }
        }
    }
    stage('build docker image from artifact') {
        steps {
            script {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }
    }
    stage('push docker image to dockerhub using ansible') {
        steps {
            script {
                sh '''
                    echo "\$ANSIBLE_VAULT_PASSWORD" > vault-passwd.txt
                    ansible-paybook ansible-deployment.yaml --vault-password-file vault-passwd.txt
                '''
                //sh 'ansible-playbook ansible-deployment.yaml --vault-password-file vault-passwd.txt'
            }
        }
    }
  }
}