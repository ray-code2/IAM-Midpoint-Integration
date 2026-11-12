package com.example.iam;

import java.sql.DriverManager;
import java.util.UUID;
import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;

class OracleMigrationIT {
    @Test
    void oracleMigrationValidatesAndReexecutionDoesNotReapplyIt() throws Exception {
        String url = required("JDBC_URL");
        String user = required("DB_USERNAME");
        String password = required("DB_PASSWORD");
        Flyway flyway = Flyway.configure().dataSource(url, user, password)
            .locations("classpath:db/migration").cleanDisabled(true).load();
        flyway.migrate();
        flyway.validate();
        assertThat(flyway.info().current().getVersion().getVersion()).isEqualTo("1");
        assertThat(flyway.migrate().migrationsExecuted).isZero();

        try (var connection = DriverManager.getConnection(url, user, password)) {
            connection.setAutoCommit(false);
            String correlation = UUID.randomUUID().toString();
            try (var insert = connection.prepareStatement(
                    "INSERT INTO IAM_AUDIT_EVENT (ACTOR_ID, ACTION, OUTCOME, CORRELATION_ID) VALUES (?, ?, ?, ?)")) {
                insert.setString(1, "ci-fixture");
                insert.setString(2, "FOUNDATION_TEST");
                insert.setString(3, "SUCCEEDED");
                insert.setString(4, correlation);
                assertThat(insert.executeUpdate()).isEqualTo(1);
            }
            try (var select = connection.prepareStatement(
                    "SELECT OUTCOME FROM IAM_AUDIT_EVENT WHERE CORRELATION_ID = ?")) {
                select.setString(1, correlation);
                try (var result = select.executeQuery()) {
                    assertThat(result.next()).isTrue();
                    assertThat(result.getString(1)).isEqualTo("SUCCEEDED");
                }
            } finally {
                connection.rollback();
            }
        }
    }

    private static String required(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) throw new IllegalStateException("Missing integration-test variable: " + name);
        return value;
    }
}
