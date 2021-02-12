pipeline {
  agent any
  stages {
    stage("Build"){
      steps{
        echo "Build the artifacts"
        sh './gradelew build --no-daemon'
        archiveArtifacts artifacts: 'dist/trainSchedule.zip'      
      }  
    }  
  }
}
