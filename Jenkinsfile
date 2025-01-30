pipeline {
  agent any
  environment {
      GIT_REPO_URL = 'https://github.com/kkpdealwis/Capstone-Project-Edureka-PGD.git'
      IMAGE_NAME = 'xyz-repo-application'
      ANSIBLE_VAULT_PASSWORD = credentials('ANSIBLE_VAULT_PASSWORD')
  }
  stages {
    stage('check ansible') {
        tools {
          ansible 'ansible-2.18.1'
        }
        steps {
            script {
              sh 'ansible --version'
            }
        }
    }
    stage('check maven') {
        tools {
          maven 'maven-3.9.9'
        }
        steps {
            script {
                sh 'mvn --version'
            }
        }
    }
    stage('build maven project artifact') {
        tools {
          maven 'maven-3.9.9'
        }
        steps {
            script{
                sh 'mvn clean install'
            }
        }
    }
    stage('run maven project tests') {
        tools {
          maven 'maven-3.9.9'
        }   
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
        tools {
          ansible 'ansible-2.18.1'
        }
        steps {
            script {
                sh '''
                    echo "\$ANSIBLE_VAULT_PASSWORD" > vault-passwd.txt
                    ansible-playbook ansible-docker-deployment.yaml --vault-password-file vault-passwd.txt
                '''
                //sh 'ansible-playbook ansible-deployment.yaml --vault-password-file vault-passwd.txt'
            }
        }
    }
    stage('deploy the application to kubernetes cluster using ansible') {
        tools {
          ansible 'ansible-2.18.1'
        }
        steps {
            script {
                sh '''
                    # awk -v workspace="${WORKSPACE}" '{gsub(/WORKSPACE/, workspace); print}' ansible.cfg > ansible.temp.cfg
                    # mv ansible.temp.cfg ansible.cfg
                    awk -v buildnumber=$BUILD_NUMBER '{gsub(/BUILD_NUMBER/, buildnumber)}1' deployment.yaml > deployment.temp.yaml
                    mv deployment.temp.yaml deployment.yaml
                    ansible-playbook -i aws_ec2.yml ansible-k8s-deployment.yaml
                '''
            }
        }
    }
  }
}
