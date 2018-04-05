def label = "jenkins-agent-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
  containerTemplate(name: 'nodegcloud', image: 'lakoo/node-gcloud-docker', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {

	node(label) {
		stage('Setup') {
		PROJECT_ID = 'devops-live'
	    APP_NAME = 'devops-react'
	    DOCKER_REPO = 'gcr.io'
	    CLUSTER_ID = 'devops'
	    CLUSTER_ZONE = 'us-east1-b'
	    GIT_BRANCH_NAME = env.BRANCH_NAME.replaceAll("[# ._]", "-").trim()
        TIMESTAMP = System.currentTimeMillis()
        IMAGE_NAME = "${DOCKER_REPO}/${PROJECT_ID}/${APP_NAME}/${GIT_BRANCH_NAME}:${TIMESTAMP}"

		    container('nodegcloud') {
				sh 'echo begin setup'
                withCredentials([file(credentialsId: 'jenkins-svc-acct', variable: 'serviceJson')]) {
					sh "gcloud config set project ${PROJECT_ID}"
					sh "gcloud auth activate-service-account --key-file=${serviceJson}"
                }

                // set the kubectl context to the proper cluster
                sh "gcloud container clusters get-credentials $CLUSTER_ID --zone=$CLUSTER_ZONE"
				checkout scm

				// TODO clean up and move to its own file
				sh """sed 's|BUILD_NUMBER|${BUILD_NUMBER}|g' src/version-template.json > version.json
                """
                sh """sed -i 's|TIME_STAMP|${TIMESTAMP}|g' version.json
                """
                sh """sed -i 's|GIT_BRANCH|${BRANCH_NAME}|g' version.json
                """
                sh """sed -i 's|IMAGE_NAME|${IMAGE_NAME}|g' version.json
                """

				sh 'echo end setup'
			}
		}

		stage('Build') {
			container('nodegcloud') {
				sh 'echo build'
				sh 'npm install'
			}
		}

		stage('Unit Test') {
			container('nodegcloud') {
				sh 'echo unit test'
				sh 'CI=true npm test'
			}
		}

		stage('Build Docker Image') {
			container('nodegcloud') {
				sh 'echo building docker image...'
                sh 'docker -v'
			}
		}

		stage('Publish Docker Image') {
			container('nodegcloud') {
				sh 'echo publishing image...'
				sh 'gcloud -v'
			}
		}

		stage('Deploy') {
			container('nodegcloud') {
				sh 'echo deploying image...'
				sh 'kubectl version'
			}
		}
	}
}