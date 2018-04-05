# Continuous Integration / Deployment / Delivery

The goal of this walkthrough is to demonstrate at a high level the concepts of CiCd and pipeline as code. You will leverage Jenkins, Docker and Kubernetes all running on Google Cloud to build, test and deploy the shell react app.

**Time to complete**: About 45 minutes

Click the **Continue** button to move to the next step.


## General App Setup and Info

**Tip**: Click the copy button on the side of the code box and paste the command in the Cloud Shell terminal to run it.

See the README.md file for info on the generated React app.

Feature branch naming recommendations are based on your pair, for example `devops-pair1`. This will ensure your branch name is compatible with the automated build pipeline. Note the branch name should not include any `_` and generally special characters should generally be avoided.

Git config:
```bash
git config --global user.name tech-agile
```

```bash
git config --global user.email techagile.github@gmail.com
```

```bash
git config --global url.https://.insteadOf git://
```

The password for the common user account will be provided in class.

Create a feature branch:
```bash
git checkout -b NAME
```

Example:
```bash
git checkout -b devops-pair10
```

Push the feature branch to the remote repository:
```bash
git push origin NAME
```

Example:
```bash
git push origin devops-pair10
```

Click the **Continue** button to move to the next step.

## Docker info
Before we work on the pipeline, let's run through the basic [Docker](https://docs.docker.com/) setup for this project.

Open the `Dockerfile` in the editor.  This is a simple setup that pulls in the latest nodejs Docker image and installs the application code. The application will be exposed on port 5000.

Build the Docker image:
```bash
docker build -t devops-react:latest .
```

View the image and copy the image ID(devops-react is the name):
```bash
docker images
```

Run the image:
```bash
docker run -d IMAGEID
```

Confirm the container is running and copy the container ID:
```bash
docker ps
```

Kill the container:
```bash
docker rm CONTAINERID -f
```

**Optional**
Open the `docker-compose.yml` file in the editor. [Docker compose](https://docs.docker.com/compose/) can be used to build and run the container. Compose is also useful for building and running multiple applications in a single container.

```bash
docker-compose up
```

The app will be exposed and running on port 5000, you can visit it by navigating to the web preview button in the top right and setting the port to 5000.

To stop the container execute `ctrl + c` in the terminal.

Click the **Continue** button to move to the next step.

## Jenkins pipeline
For creating the pipeline you will build out a `Jenkins` file (template provided).  A [Jenkins](https://jenkins.io/) instance that is already running will execute the steps you define in the pipeline. Newly pushed commits/branches will be detected automatically by branch name.

View the Jenkinsfile in the editor and take note of the stages:

Sample:
```
stage('Build') {
	container('nodegcloud') {
		sh 'echo build'
	}
}
```
We will be modifying the code in the stages to execute build, test and deploy.

Access Jenkins (credentials provided in class):
```
http://jenkins.techagile.training:8080/
```

Navigate to the `devops-react` project and open it...you should see your feature branch and the status of the build (remember, we executed a git push at the begining of the walkthrough). Take a look around at the steps in the Jenkins UI pipeline, they correspond to the `stage` variable in the `Jenkinsfile`.

Now, let's add some functionality to those steps.

Click the **Continue** button to move to the next step.

## Unit Test
Open the `Jenkinsfile` and the unit test execution script in the Unit Test stage.
```bash
sh 'CI=true npm test'
```

Once complete the section should look like below:
```
stage('Unit Test') {
	container('nodegcloud') {
		sh 'echo unit test'
		sh 'CI=true npm test'
	}
}
```

Execute the git commands to push the change to the remote branch:
```bash
git add Jenkinsfile
```
```bash
git commit -m "Add unit testing"
```
```
git push origin <branchname>
```

Head back over to [Jenkins](http://jenkins.techagile.training:8080/job/devops-react/) to see the build running...

Click the **Continue** button to move to the next step.

## Fix the fake test
A failing test was put into place to ensure the build process caught it. Fix the test and push the code out again.

In the `src/App.test.js` file, remove the failing test.
```javascript
it('fails for demo purposes', () => {
  expect(true).toEqual(false);
});
```

```bash
git add src/App.test.js
```
```bash
git commit -m "Fix failing test"
```
```bash
git push origin <branchname>
```

Click the **Continue** button to move to the next step.

## Build the docker image

Update the `Build Docker Image` stage in the `Jenkinsfile`:

```
stage('Build Docker Image') {
	container('nodegcloud') {
		sh 'echo building image...'
		sh "docker build -t ${IMAGE_NAME} ."
	}
}
```

Click the **Continue** button to move to the next step.

## Publish the image and deploy

Push the docker image to the Google Container Registry and then deploy it to the defined cluster.

```
stage('Publish Docker Image') {
	container('nodegcloud') {
		sh 'echo publishing image...'
		sh "gcloud docker -- push ${IMAGE_NAME}"
	}
}
```

The `Deploy` stage has been added already due to being error prone with the markdown.

Uncomment the `Deploy` stage in the `Jenkinsfile`.

Add the Kubernetes deployment configuration file:
`k8s-template.yaml`
```yaml
---
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: devops-react-{{GIT_BRANCH_NAME}}
  labels:
    app: devops-react
    branch: {{GIT_BRANCH_NAME}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: devops-react
      branch: {{GIT_BRANCH_NAME}}
  template:
    metadata:
      labels:
        app: devops-react
        branch: {{GIT_BRANCH_NAME}}
    spec:
      containers:
      - name: devops-react
        image: {{IMAGE_NAME}}
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: devops-react-{{GIT_BRANCH_NAME}}
  labels:
    app: devops-react
    branch: {{GIT_BRANCH_NAME}}
spec:
  selector:
    app: devops-react
    branch: {{GIT_BRANCH_NAME}}
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080```

Push the changes to the remote branch:
```bash
git add Jenkinsfile
```

```bash
git commit -m "Publish the docker image and deploy."
```
```bash
git push origin <branchname>
```
If the build was successful, the app will be deployed to the `devops` cluster defined in the `Jenkins` file.

Click the **Continue** button to move to the next step.

## Congrats!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>