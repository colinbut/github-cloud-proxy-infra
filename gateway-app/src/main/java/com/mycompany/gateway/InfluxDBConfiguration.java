package com.mycompany.gateway;

import org.influxdb.InfluxDB;
import org.influxdb.InfluxDBFactory;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Collection;

@Configuration
public class InfluxDBConfiguration {

    public static final String ASSIGNMENT_DATABASE = "githubcloudproxy";

    @Value("${kpi.database-url}")
    private String databaseUrl;

    @Value("${kpi.database-username}")
    private String username;

    @Value("${kpi.database-password}")
    private String password;

    @Bean
    public InfluxDB createConnection() {
        InfluxDB influxDB = InfluxDBFactory.connect(databaseUrl, username, password);

        if(!databaseExists(influxDB)) {
            createDatabase(influxDB);
        }

        return influxDB;
    }

    private boolean databaseExists(InfluxDB influxDB) {

        Query query = new Query("show databases", null, true);
        QueryResult queryResult = influxDB.query(query);

        return queryResult.getResults().stream()
                .flatMap(s -> s.getSeries().stream())
                .filter(s -> s.getName().equals("databases"))
                .flatMap(s -> s.getValues().stream())
                .flatMap(Collection::stream).anyMatch(s -> s.equals(ASSIGNMENT_DATABASE));
    }

    private void createDatabase(InfluxDB influxDB) {

        Query query = new Query(String.format("CREATE DATABASE \"%s\"", ASSIGNMENT_DATABASE),null,true);
        QueryResult queryResult = influxDB.query(query);
        if(queryResult.hasError()) {
            throw new RuntimeException("Could not create database");
        }
    }

}
