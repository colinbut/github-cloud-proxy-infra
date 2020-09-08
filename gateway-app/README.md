# Gateway App

In order to use this application you need to have [Java 8](https://www.oracle.com/technetwork/java/javase/overview/java8-2100321.html) installed as well as [Maven](http://maven.apache.org/).

To compile the application

```
mvn clean package
```

To run the application

```bash
KPI_DATABASE_URL=http://influxdb-url KPI_DATABASE_PASSWORD=password KPI_DATABASE_USERNAME=username mvn spring-boot:run
```

To dockerize the application

```bash
docker build -t 'githubcloudproxy:latest' .
```

The image can be found on [dockerhub](https://hub.docker.com/r/colinbut/githubcloudproxy)

To run using docker compose

```bash
docker-compose -f docker-compose.yaml up
```

Then you can use the gateway app proxy functionality

```bash
curl http://localhost:8080/positions.json?page=0
```

You can monitor the service health status with the following endpoint

```bash
curl http://localhost:8080/actuator/health
```

