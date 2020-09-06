# sample-web-application
A sample web application with golang 

## Getting Started

These instructions will show the journey of a web application, from local system to k8s. The steps will be as follows.

**1-** Development of the web application. This project has been coded with golang.

**2-** Containerization of the application

**2.1-** Building image with Dockerfile
  
**2.2-** Deploying image to DockerHub

**3-** Automating step-2 with a pipeline

**4-** Deploying web applcation to K8s cluster



### Prerequisites

This project has been developed withing the following:

**1-** **Golang** development environment

**2-** **Docker** environment

**3-** **Jenkins**

**4-** **Minikube**, as a k8s cluster

**5-** **kubectl** configured to be used with Minikube


### Let's start the journey, step-by-step

**1-** Clone the project:

    git clone https://github.com/kaktas35tr/sample-web-application.git
    
**2-** Run **web-app.go** file

    go run web-app.go

It will kick of a server on **http://localhost:11130** . Open a browser to visit this server to verify if your web-app.go file works.

* You can change the text message in *responseHandler* function.
* You can configure the port to listen, in *ListenAndServe* line.

**3-** Build docker image locally by using **Dockerfile**
   
     docker build -t web-app .
 
**4-** Verify that the image exists on local machine
 
     docker images

* You should see your image with size 12 MB.

**5-** Run the image 

     docker run -p 11130:11130 -it web-app

This exposes application which is running on port 11130 within the container on http://localhost:11130 on our local machine.

**6-** Deploy the image to DockerHub

Use **Jenkinsfile** which clones the project, builds docker image and pushes to public docker registry, **kaktas35/sample-web-application** in this case.
The latest image is **kaktas35/sample-web-application:v.12** in our case. 

**7-** Start k8s cluster

    minikube start --extra-config kubelet.EnableCustomMetrics=true
    minikube addons enable metrics-server
    
**8-** Create deployment and service for web-app

    kubectl apply -f web-app-whole-manifest.yml

Please not that the image is **kaktas35/sample-web-application:v.12** in our case. You need to ensure if your manifest file matches with your image.

**9-** Create horizontal pod autoscaler 
 
    kubectl apply -f web-app-whole-autoscale.yml
 
This will create HPA based on the requests through web-app

**10-** Expose web-app to reach to container

    minikube tunnel

**11-** Bombard web-app with http requests. Run the following command in a different terminal

    kubectl run -it --rm load-generator --image=busybox /bin/sh
    Hit enter for command prompt
    while true; do wget -q -O- http://$pod_ip:11130; done
    
 This will send lots of requests to web-app. 
 
 **12-** Check the hpa and pods with following commands
 
     kubectl get hpa web-app
 
 Within a few minutes, we should see the higher CPU load, and so that HPA will increase the number of replicas
 
 **13-** When load-generator is stopped, with Ctrl+C, HPA will resize web-app replicas again to minimum size.
 
 * This may take a bit longer. 
 
