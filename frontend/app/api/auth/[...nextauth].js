import NextAuth from "next-auth/next";
import KeycloakProvider from 'next-auth/providers/keycloak'


export const authOptions = {
    provider: [
        KeycloakProvider({
            clientId: process.env.NEXT_PUBLIC_KEYCLOAK_CLIENT_ID,
            clientSecret: process.env.NEXT_PUBLIC_KEYCLOAK_CLIENT_SECRET,
            issuer: process.env.KEYCLOAK_ISSUER,
        })
    ]
}

export default NextAuth(authOptions)