pipeline {
  agent any
  stages {
    stage("Build"){
      steps{
        echo "Build the artifacts"
        sh './gradlew build --no-daemon'
        archiveArtifacts artifacts: 'dist/trainSchedule.zip'      
      }  
    }  
  }
}
