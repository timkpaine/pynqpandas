pipeline {
    agent any
        stages {
            stage('Build') {
                steps {
                    echo 'No Build Step.'
                }
                post {
                    success {
                        echo 'Build succeeded.'
                    }
                    failure {
                        echo 'Build failed.'
                    }
                }
            }
            stage('Deploy') {
                when {
                    branch 'master'
                }
                steps {
                    echo 'This is the Deploy Stage'
                }
                post {
                    success {
                        echo 'Deploy succeeded'
                    }
                    failure {
                        echo 'Deploy failed'
                    }
                }
            }
        }
    }
