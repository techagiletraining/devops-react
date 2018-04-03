# Continuous Integration / Deployment / Delivery

The goal of this walkthrough is to demonstrate at a high level the concepts of CiCd and pipeline as code. You will leverage Jenkins, Docker and Kubernetes all running on Google Cloud to build, test and deploy the shell react app.

**Time to complete**: About 45 minutes

Click the **Continue** button to move to the next step.

## General App Setup and Info

**Tip**: Click the copy button on the side of the code box and paste the command in the Cloud Shell terminal to run it.

See the README.md file for info on the generated React app.

Feature branch naming recommendations are first letter of your pair ID, for example `devops-pair1`. This will ensure your branch name is compatible with the automated build pipeline. Note the branch name should not include any `_` and generally special characters should generally be avoided.

Git config:
```bash
git config --global user.name tech-agile
```

```bash
git config --global user.email techagile.github@gmail.com
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

View the image and note the image ID:
```bash
docker images
```

Run the image:
```bash
docker run -d IMAGEID
```

Confirm the container is running and note the container ID:
```bash
docker ps
```

Kill the container:
```bash
docker rm CONTAINERID -f
```

**Optional**
Open the `docker-compose.yml` file in the editor. [Docker compose](https://docs.docker.com/compose/) can be used to build and run the container and is useful for building and running multiple applications in a single container.

```bash
docker-compose up
```

The app will be exposed and running on port 5000, you can visit it by navigating to the web preview button in the top right and setting the port to 5000.

To stop the container execute `ctrl + c` in the terminal.

Click the **Continue** button to move to the next step.

## Jenkins pipeline
For creating the pipeline you will build out a `Jenkins` file (template provided).  A [Jenkins](https://jenkins.io/) instance that is already running will execute the steps you define in the pipeline and newly pushed commits/branches will be detected automatically by branch name.

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

Navigate to the `devops-react` project and open it...you should see your feature branch and the status of the build. Take a look around at the steps in the Jenkins UI pipeline, they correspond to the `stage` variable in the `Jenkinsfile`.

Now, let's add some functionality to those steps.

Click the **Continue** button to move to the next step.

## Congrats!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>