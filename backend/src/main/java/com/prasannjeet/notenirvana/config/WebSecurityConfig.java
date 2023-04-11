package com.prasannjeet.notenirvana.config;

import static org.springframework.http.HttpMethod.GET;

import com.prasannjeet.notenirvana.config.util.JwtAudienceValidator;
import com.prasannjeet.notenirvana.config.util.JwtAuthConverter;
import com.prasannjeet.notenirvana.config.util.RolesLoggingFilter;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.core.OAuth2TokenValidator;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoders;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.channel.ChannelProcessingFilter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

  public static final String ADMIN = "admin";
  public static final String USER = "user";
  private static final String DEFAULT_AUDIENCE = "account";
  private final JwtAuthConverter jwtAuthConverter;

  @Value("${spring.security.oauth2.resourceserver.jwt.issuer-uri}")
  private String issuerUri;

  @Value("${jwt.auth.converter.resource-id}")
  private String resourceId;

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    CorsFilter corsFilter = new CorsFilter(corsConfigurationSource());
    http.authorizeHttpRequests()
        .requestMatchers(GET, "/test/anonymous", "/test/anonymous/**")
        .permitAll()
        .requestMatchers(
            GET,
            "/swagger-ui.html/**",
            "/swagger-ui/**",
            "/swagger-resources/**",
            "/v3/api-docs/**",
            "/v2/api-docs",
            "/webjars/**",
            "/csrf")
        .permitAll()
        .requestMatchers(GET, "/test/admin", "/test/admin/**")
        .hasRole(ADMIN)
        .requestMatchers(GET, "/test/user")
        .authenticated()
        .anyRequest()
        .authenticated();
    http.oauth2ResourceServer().jwt().jwtAuthenticationConverter(jwtAuthConverter);
    http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);

    // Add a custom filter to log the user roles
    http.addFilterBefore(new RolesLoggingFilter(), UsernamePasswordAuthenticationFilter.class);

    // Add the CORS filter directly to the security filter chain
    http.addFilterBefore(corsFilter, ChannelProcessingFilter.class);

    // Enable CORS with the custom configuration
    //    http.cors();

    return http.build();
  }

  @Bean
  public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(
        List.of(
            "http://localhost:3000/",
            "http://localhost:3000",
            "https://notenirvana.ooguy.com/",
            "https://notenirvana.ooguy.com"));
    configuration.setAllowedMethods(List.of("*")); // Allow all methods (GET, POST, etc.)
    configuration.setAllowedHeaders(List.of("*")); // Allow all headers
    configuration.setAllowCredentials(true); // Allow credentials

    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
  }

  @Bean
  public JwtDecoder jwtDecoder() {
    NimbusJwtDecoder jwtDecoder = (NimbusJwtDecoder) JwtDecoders.fromIssuerLocation(issuerUri);
    OAuth2TokenValidator<Jwt> withAudience = new JwtAudienceValidator(DEFAULT_AUDIENCE);
    OAuth2TokenValidator<Jwt> withIssuer = JwtValidators.createDefaultWithIssuer(issuerUri);
    OAuth2TokenValidator<Jwt> validator =
        new DelegatingOAuth2TokenValidator<>(withIssuer, withAudience);
    jwtDecoder.setJwtValidator(validator);
    return jwtDecoder;
  }
}

// hasAnyRole(ADMIN, USER)
