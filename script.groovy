def buildJar() {
    echo "building the application..."
    sh 'mvn package'
} 


def buildDockerImage(String imageName) {
        echo "building the docker image..."
        sh "docker build -t $imageName ."
}

def dockerLogin() {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        sh "echo $PASS | docker login -u $USER --password-stdin"
        }
}

    def dockerPush(String imageName) {
        sh "docker push $imageName"
    }


def deployApp() {
    echo 'deploying the application...'
} 

return this
