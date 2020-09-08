package com.mycompany.gateway;

import java.time.Instant;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.web.server.ServerWebExchange;

import reactor.core.publisher.Mono;

@Configuration
public class RouterConfig {

    private final Vector v = new Vector();

    @Autowired
    protected InfluxDBRepository influxDBRepository;

    @Bean
    public RouteLocator myRoutes(RouteLocatorBuilder builder) {
        return builder.routes()
                      .route(p -> p
                              .path("/positions.json")
                              .uri("https://jobs.github.com"))
                      .build();
    }

    @Bean
    @Order(-1)
    public GlobalFilter logFilter() {
        return (exchange, chain) ->
        {
            logToKPI(exchange);
            return chain.filter(exchange).then(Mono.fromRunnable(() -> { addToVector(); }));
        };
    }

    /**
     * This creates a memory problem
     */
    private void addToVector() {
        byte b[] = new byte[16777216];
        v.add(b);
        Runtime rt = Runtime.getRuntime();
        System.out.println( "free memory: " + rt.freeMemory() );
    }

    /**
     * Async action
     * @param serverWebExchange
     */
    private void logToKPI(ServerWebExchange serverWebExchange) {
        String method = serverWebExchange.getRequest().getMethodValue();
        Integer statusCode = serverWebExchange.getResponse().getStatusCode().value();
        RequestMetric requestMetric = new RequestMetric();
        requestMetric.setTime(Instant.now());
        requestMetric.setMethod(method);
        requestMetric.setStatus(statusCode);

        influxDBRepository.addMetric(requestMetric);
    }
}
