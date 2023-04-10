import Navbar from './components/Navbar'
import './globals.css'

export const metadata = {
  title: 'Nirvana Notes',
  description: 'Your productivity note taking app.',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <Navbar />
        <main>
        {children}
        </main>
      </body>
    </html>
  )
}
