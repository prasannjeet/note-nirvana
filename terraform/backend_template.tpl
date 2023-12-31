
# Keycloak Auth
KEYCLOAK_SCHEME=https
KEYCLOAK_AUTH_SERVER=keycloak.ooguy.com
KEYCLOAK_AUTH_PORT=443
REALM_NAME=timetable-oauth
KEYCLOAK_PUBLIC_KEY=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA21rviEvOYeypQ59TnEIAAm9q1iAcCk2pE6I7pEvfH6nzREFsUKhKV8l6L1x1r7HFgzGS/Nt0mHMVMX0kSq72g5yIisAIpm16UyU8Gl9fEhxpbSNUpWX452p+ZFVgYetAc8rO94sHkRqFbmm7RfCT646NkRi3uN3iYiJC3ZBqngxHzgH9j2FThxVyptgsPCy6LgSFJn6YYq3X/MD2QTew8oKLQlq9ZFU4QPxf6+yzqtiLxgYR4cLFghSv1fDY3USMqcNJlQtFQNvF5GbXjWuWkKLpTilMDpip55x5rC/5o7ySzyd0PjpfEWsELFErZu4DQ8/9qstXKTl4CTSjrePNIQIDAQAB
KEYCLOAK_CLIENT_ID=note-nirvana
KEYCLOAK_CLIENT_SECRET=YkjNiyiF8XzFcrCRNDizJfgzoc3dBJKX

DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

EXTRA_JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005

ALLOWED_ORIGINS=${ALLOWED_ORIGINS},${ALLOWED_ORIGINS_EXT}

