FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
COPY certificate.pem /opt/keycloak/
COPY privatekey.pem /opt/keycloak/

RUN openssl pkcs12 -export -in /opt/keycloak/certificate.pem -inkey /opt/keycloak/privatekey.pem -out /opt/keycloak/pkcs12keystore.p12 -name server -passout pass:password && \
    keytool -importkeystore -deststorepass password -destkeypass password -destkeystore /opt/keycloak/conf/server.keystore -srckeystore /opt/keycloak/pkcs12keystore.p12 -srcstoretype PKCS12 -srcstorepass password -alias server

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://192.168.1.103:5432/keycloak
ENV KC_DB_USERNAME=keycloak
ENV KC_DB_PASSWORD=rdTg*bm4pfd2CE9@7ewxAKKYG48Hj7DMWu-
ENV KC_HOSTNAME=localhost
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
