package com.example.iam.database;

import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
import org.springframework.boot.health.contributor.Health;
import org.springframework.boot.health.contributor.HealthIndicator;

@Configuration
@Profile("oracle")
public class OracleConfiguration {
    @Bean(initMethod = "migrate")
    Flyway flyway(Environment environment) {
        return Flyway.configure()
            .dataSource(environment.getRequiredProperty("JDBC_URL"),
                environment.getRequiredProperty("DB_USERNAME"),
                environment.getRequiredProperty("DB_PASSWORD"))
            .locations("classpath:db/migration")
            .cleanDisabled(true)
            .validateMigrationNaming(true)
            .load();
    }

    @Bean
    HealthIndicator oracleHealthIndicator(Flyway flyway) {
        return () -> {
            try (var connection = flyway.getConfiguration().getDataSource().getConnection()) {
                return connection.isValid(5) ? Health.up().build() : Health.down().build();
            } catch (Exception failure) {
                // Health details never expose connection settings or credentials.
                return Health.down().build();
            }
        };
    }
}
