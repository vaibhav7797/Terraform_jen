pipeline {
    agent {
        kubernetes {
            yaml '''
              apiVersion: v1
              kind: Pod
              spec:
                volumes:
                - name: hostpath-privileged
                  hostPath:
                    path: /var/run/docker.sock
                containers:
                - name: helm 
                  image: alpine/helm:3.1.1
                  command:
                  - cat
                  tty: true
                - name: jdk
                  image: sonarsource/sonar-scanner-cli
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: hostpath-privileged
                - name: npm
                  image: node:12.16.2-alpine
                  command:
                  - cat
                  tty: true  
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: hostpath-privileged
                - name: helm-aws
                  image: jshimko/kube-tools-aws:3.8.1
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: hostpath-privileged
                - name: docker-aws
                  image: rubixcubin/dockerawscliv2
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: hostpath-privileged
                - name: terraform-aws
                  image: ubuntu:20.04
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: hostpath-privileged

                    
            '''
        }
    }

      stages {
          stage('Git Clone') {              
            steps {  
               checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vaibhav7797/Terraform_jen']]])
            }
        }
        stage('code-scanner') { 
                  
                  steps {
                    echo 'code scanning....'
                    withCredentials([string(credentialsId: 'sonarqube-secret', variable: 'sonarqube-secret')]) {
                    container("jdk") {
                      sh 'sonar-scanner \
                          -Dsonar.projectKey=cd_test_terraform_code \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=https://sonarqube.shared.youareaceo.com \
                          -Dsonar.login=sqp_951ff995f44a22931b069946c4da98b17adadb88'
             }
            }
           }  
          }
       stage ("terraform format") {
           steps {
            echo 'terraform format...'
            withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
                container("terraform-aws") {
                  script {
                    sh 'apt update && apt install curl -y && apt install unzip -y && apt install sudo -y && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip  && sudo ./aws/install && aws --version'
                      sh 'apt install wget -y && apt install git -y && wget --quiet https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip && unzip terraform_1.0.8_linux_amd64.zip && mv terraform /usr/bin && terraform --version'
                      sh 'export AWS_ACCESS_KEY_ID=${jenkins_access_key} && export AWS_SECRET_ACCESS_KEY=${jenkins_secret_key} '
                      sh 'aws --version && terraform --version'
                      sh 'terraform fmt'
                  }
           }
       }
       }
       }
       stage ("terraform init") {
            steps {
               echo 'Terraform init...'
              withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
                container("terraform-aws") {
                  script {
                      sh 'export AWS_ACCESS_KEY_ID=${jenkins_access_key} && export AWS_SECRET_ACCESS_KEY=${jenkins_secret_key} && terraform init'
            }
        }
              
      }
    }
  }
        stage ("terraform validate") {
            steps {
               echo 'Terraform Validate...'
              withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
                container("terraform-aws") {
                  script {

                    sh 'terraform validate'
            }
        }
              
      }
    }
  }
        stage ("terraform plan ") {
            steps {
               echo 'Terraform plan ..'
              withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
                container("terraform-aws") {
                  script {

                    sh 'export AWS_ACCESS_KEY_ID=${jenkins_access_key} && export AWS_SECRET_ACCESS_KEY=${jenkins_secret_key} && terraform plan '
            }
        }
              
      }
    }
  }
      
        stage("Approval") {
            steps {    
                echo 'Approve..'
                 withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
            container("terraform-aws") {
                script {
                  def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
    }
  }
}
}
}
        stage ("terraform action") {
            steps {
                echo 'Terraform action '
                withCredentials([string(credentialsId: 'cd_test_access_key', variable: 'jenkins_access_key'),string(credentialsId: 'cd_test_secret_key', variable: 'jenkins_secret_key')]) {
            container("terraform-aws") {
                  script {
                      sh 'export AWS_ACCESS_KEY_ID=${jenkins_access_key} && export AWS_SECRET_ACCESS_KEY=${jenkins_secret_key} && terraform ${action} -refresh=true -auto-approve'

  }
  }
 }
  
      }
}
}
}
       


       