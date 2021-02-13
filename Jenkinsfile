pipeline {
  environment {
    registry = "mramkumar/train-schedule"
    registryCredential = 'docker-login'
    dockerHost  = 'docker'
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
                                    execCommand: 'rm -rf /tmp/train-schedule && mkdir /tmp/train-schedule && unzip /tmp/trainSchedule.zip -d /tmp/train-schedule'
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
      	node('docker') {
		dir('/tmp/train-schedule') {
		        script {
        		  dockerImage = docker.build registry + ":$BUILD_NUMBER"
	        	}
		}
	}
      }
    }
    stage('Push Image') {
      steps{
	node('docker') {
     	   script {
        	  docker.withRegistry( '', registryCredential ) {
	            dockerImage.push()
        	  }
	        }
      	   }
	}
	
    }
    stage('Removed unused Image') {	
		steps {
			node('docker') {
				sh "docker rmi $registry:$BUILD_NUMBER"
			}

		}
   }

   stage('Remove existing Container from Production') {
		steps{
			node('docker') {
				sh 'docker stop train-schedule || true && docker rm train-schedule|| true'
			}
		}

   } 

   stage('Deploy to Production') {
	steps {
		node('docker') {
		script {
			docker.withRegistry( '', registryCredential ) {
				docker.image(registry + ":$BUILD_NUMBER").run('-p 3000:3000 --name train-schedule'){ c ->
					sh "docker logs ${c.id}"
				}
	
			}				

			
		}
		}

	}

}


}
}
