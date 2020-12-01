## FRFR-Sevice PostgreSQL Docker Image
This document contains instructions to build and run the FRFR-SERVICES PostgreSQL docker image locally in a VM.

It assumes you currently have a running Linux VM with Docker installed.

<b>Note: This is still a work in progress.</b>
<br/><br/>


### Building the Image
Open a terminal and run the following command in the same folder in which the Dockerfile resides.
Note you can rename 'frfr-services-db' to whatever you like.
```
docker build -t frfr-services-db .
```
<br/>

### Running the Image
Run the image using the Docker command below.  This will start the container named frfr-services-db on port 5432
with username frfr-services and password frfr-services.
```
docker run --name frfr-services-db --env POSTGRES_USER=frfr_services_app_user --env POSTGRES_PASSWORD=frfr_services_app_user --publish 5432:5432 --detach frfr-services-db
```
<br/>

Once the container exists on your machine, simply execute the commands below to start/stop the container:
```
docker start frfr-services-db
```
or
```
docker stop frfr-services-db
```
<br/>

### JDBC Connection Info
```
JDBC Url: jdbc:postgresql://localhost:5432/frfr
Username: frfr_services_app_user
Password: frfr_services_app_user
```
<br/>

### Troubleshooting
If the container won't start or you run into any issues I have found it helpful to tail the container logs at startup.
It is also helpful to view logs while migrating applications to PostgreSQL as it shows specific queries that fail due to whatever reason.
```
docker logs -f frfr-services-db
```
