package com.example.iam;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HealthAndSecurityTest {
    @LocalServerPort
    int port;

    private HttpResponse<String> get(String path) throws Exception {
        return HttpClient.newHttpClient().send(
            HttpRequest.newBuilder(URI.create("http://localhost:" + port + path)).GET().build(),
            HttpResponse.BodyHandlers.ofString());
    }

    @Test
    void publicHealthReportsUpWithoutInternalDetails() throws Exception {
        var response = get("/api/health");
        assertThat(response.statusCode()).isEqualTo(200);
        assertThat(response.body()).contains("\"status\":\"UP\"").doesNotContain("components", "password");
    }

    @Test
    void businessApiIsDeniedUntilAuthenticationIsImplemented() throws Exception {
        assertThat(get("/api/employees").statusCode()).isEqualTo(403);
    }

    @Test
    void operationalConfigurationIsNotPublic() throws Exception {
        assertThat(get("/api/env").statusCode()).isEqualTo(403);
        assertThat(get("/actuator/env").statusCode()).isEqualTo(403);
    }
}
