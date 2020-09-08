package com.mycompany.gateway;

import org.influxdb.InfluxDB;
import org.influxdb.impl.InfluxDBMapper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

@Repository
public class InfluxDBRepository {

    private final InfluxDB influxDB;
    private final InfluxDBMapper influxDBMapper;

    public InfluxDBRepository(InfluxDB influxDB) {
        this.influxDB = influxDB;
        this.influxDBMapper = new InfluxDBMapper(influxDB);
    }

    @Async
    public void addMetric(RequestMetric requestMetric) {
        influxDBMapper.save(requestMetric);
    }

}
