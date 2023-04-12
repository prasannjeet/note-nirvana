'use client'

import {useState} from 'react'
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";
import { useRouter } from 'next/navigation';

const NewNotePage = () => {
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')

 const router = useRouter()

  const { token } = useNextKeycloakAuth();


  const handleSubmit = async (e) => {
    e.preventDefault()
    
    const res = await fetch('https://nirvana.ooguy.com/api/v1/notes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        title,
        content
      })
    })

    const data = await res.json()
    
    console.log("Submitted DATA:",data);

    if (data) {
      router.push(`/notes`)
    }

  }

  return (
    <div className='flex flex-col justify-center content-center items-center my-6 rounded-sm'>
      <form onSubmit={handleSubmit} className='flex flex-col py-4 px-4 bg-gray-200 w-1/2'>
        <label htmlFor="title">Title</label>
        <input className='h-10 px-2 rounded-md' type="text" name="title" id="title" onChange={(e) => setTitle(e.target.value)} />
        <label htmlFor="content">Content</label>
        <textarea className='rounded-md h-12 px-2 py-2' name="content" id="content" onChange={(e) => setContent(e.target.value)} />
        <div className='py-4 mx-auto'>
          <button type='submit' className='bg-green-600 text-white rounded-md py-2 px-2 hover:bg-green-700'>Add note</button>
        </div>
      </form>
    </div>
  )
}

export default NewNotePage