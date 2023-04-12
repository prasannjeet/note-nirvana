'use client'
import Navbar from './components/Navbar'
import './globals.css'
import {NextKeycloakAuthProvider} from "@krashnakant/next-keycloak";
import { SessionProvider } from "next-auth/react";

// export const metadata = {
//     title: 'Nirvana Notes',
//     description: 'Your productivity note taking app.',
// }

const config = {
    realm: process.env.NEXT_PUBLIC_KEYCLOAK_REAM,
    url: process.env.NEXT_PUBLIC_KEYCLOAK_URL,
    clientId: process.env.NEXT_PUBLIC_KEYCLOAK_CLIENT_ID,
};

const initOption = {
    onLoad: 'check-sso',
    /* silentCheckSsoRedirectUri:
        'http://localhost:3000/silent-check-sso.html', */
};

export default function RootLayout({children, session}) {
    return (
        <html lang="en">
        <body>
        <NextKeycloakAuthProvider config={config} initOption={initOption}>
            <Navbar/>
            <main>
                {children}
            </main>
        </NextKeycloakAuthProvider>
        </body>
        </html>
    )
}
