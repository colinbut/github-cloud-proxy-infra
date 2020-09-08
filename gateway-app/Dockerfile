FROM openjdk:8-jre-alpine
COPY target/gateway-*-SNAPSHOT.jar /app.jar
RUN chmod +x /app.jar
CMD ["/usr/bin/java", "-jar", "/app.jar"]