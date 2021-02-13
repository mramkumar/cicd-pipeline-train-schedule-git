pipeline {
  environment {
    registry = "mramkumar/train-schedule"
    registryCredential = 'password-0335'
    dockerImage = ''
  }
agent any
stages {
    stage('Build') {
        steps {
            echo 'Running build automation'
            sh './gradlew build --no-daemon'
            archiveArtifacts artifacts: 'dist/trainSchedule.zip'
        }
    }
    stage('Copy Build') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                sshPublisher(
                    failOnError: true,
                    continueOnError: false,
                    publishers: [
                        sshPublisherDesc(
                            configName: 'staging',
                            sshCredentials: [
                                username: "$USERNAME",
                                encryptedPassphrase: "$USERPASS"
                            ],
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'dist/trainSchedule.zip',
                                    removePrefix: 'dist/',
                                    remoteDirectory: '/tmp',
                                    execCommand: 'rm -rf /tmp/train-schedule || mkdir /tmp/train-schedule || unzip -d /tmp/trainSchedule.zip -d /tmp/train-schedule'
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
   stage('Building image') {
      steps{
      	node('docker')
	cd /tmp/train-schedule
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image') {
      steps{
	node('docker')
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

}
}

