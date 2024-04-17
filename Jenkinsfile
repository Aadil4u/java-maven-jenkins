def gv

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    parameters {
        string description: 'your local machine ip_addr', name: 'local_ip_addr', trim: true
        string description: 'your jenkins machine ip_addr', name: 'jenkins_ip_addr', trim: true
    }

    environment {
        IMAGE_NAME = 'aadilpatni4u/java-app:6.0'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        
        stage("build jar") {
            steps {
                script {
                    gv.buildJar()
                }
            }
        }
        
        stage("build and push image") {
            steps {
                script {
                    gv.buildDockerImage(env.IMAGE_NAME)
                    gv.dockerLogin()
                    gv.dockerPush(env.IMAGE_NAME)
                }
            }
        }

        stage("provision server") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws_access_key')
                AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
                TF_VAR_my_ip = "${params.local_ip_addr}"
                TF_VAR_jenkins_ip = "${params.jenkins_ip_addr}"
            }
            steps {
                script {
                    dir('terraform'){
                        sh 'terraform init'
                        sh 'terraform apply --auto-approve'
                        env.EC2_PUBLIC_IP = sh(
                            script: "terraform output public_ip",
                            returnStdout: true
                        ).trim()
                    }                  
                }
            }
        }
        
       stage('deploy') {
            environment {
                DOCKER_CRED = credentials('docker-hub-repo')
            }
            steps {
                script {
                    echo 'waiing for ec2 server to initialize'
                    sleep(time:90, unit: "SECONDS")

                   echo 'deploying docker image to EC2...'
                   echo "${env.EC2_PUBLIC_IP}"

                   def shellCmd = "bash ./server-cmds.sh ${env.IMAGE_NAME} ${DOCKER_CRED_USR} ${DOCKER_CRED_PSW}"
                   def ec2Instance = "ec2-user@${env.EC2_PUBLIC_IP}"

                   sshagent(['ec2-server-key']) {
                       sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                       sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                       sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                   }
                }
            }
        }

    }
}
