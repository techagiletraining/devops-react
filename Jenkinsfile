stage('Build') {
	container('nodegcloud') {
		sh 'echo build'
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
		sh 'echo building image...'
		sh "docker build -t ${IMAGE_NAME} ."
	}
}


stage('Publish Docker Image') {
	container('nodegcloud') {
		sh 'echo publishing image...'
		sh "gcloud docker -- push ${IMAGE_NAME}"
	}
}
