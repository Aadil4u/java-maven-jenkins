def gv

pipeline {
    agent any
    tools {
        maven 'Maven'
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
        
       stage('deploy') {
            steps {
                script {
                   echo 'deploying docker image to EC2...'

                   def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                   def ec2Instance = "ec2-user@3.110.120.190"

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
