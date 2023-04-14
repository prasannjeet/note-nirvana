'use client'

import {useState, useEffect} from 'react'
import Link from "next/link"
import { FaArrowLeft, FaEdit, FaTrash } from "react-icons/fa"
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";
import { useRouter } from 'next/navigation';


const NotePage = ({ params: { id } }) => {
    const [note, setNote] = useState();
    const [editForm, setEditForm] = useState(false);
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');

    const { token, authenticated } = useNextKeycloakAuth();

    const router = useRouter()

    useEffect(() => {
        const fetchNote = async () => {
            if (authenticated) {
                const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/notes/${id}`, {
                    headers: {
                        Accept: 'application/json',
                        Authorization: `Bearer ${token}`,
                    },
                });
                const data = await res.json();
                setNote(data);
            } else {
                console.log('error');
            }
        };
        fetchNote().catch((err) => {
            alert('Error fetching notes, or no notes exist. Please try again later. Check console for error.');
            console.log(err);
        });
    }, [token, authenticated]);

    // delete note
    const handleDelete = async () => {
        const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/notes/${id}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                Accept: "application/json",
                Authorization: `Bearer ${token}`,
            },
        });
        router.push(`/notes`)
    }

    const openEditForm = () => {
        setEditForm(!editForm);
    }

    const handleSubmit = async (e) => {
        e.preventDefault()

        const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/notes/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                Accept: "application/json",
                Authorization: `Bearer ${token}`,
            },
            body: JSON.stringify({
                title: title,
                content: content
            })
        })

        const data = await res.json()
        setNote(data)
        if (data) {
            router.push(`/notes/${id}`)
            setEditForm(false)
        }
    }



    return (
        <>
            {note ? (
                <>
                    <div className="mx-4 my-4 flex justify-between">
                        <Link className="py-4 px-4 bg-gray-400 rounded-md text-white" href={"/notes"}>
                            <FaArrowLeft />
                        </Link>
                        <div className="flex">
                            <FaTrash className="mr-4 cursor-pointer" onClick={handleDelete} />
                            <FaEdit className='cursor-pointer' onClick={openEditForm} />
                        </div>
                    </div>
                    <section className="flex flex-col justify-center content-center items-center">
                        <div>
                            <h1>{note.title}</h1>
                        </div>
                        <div className="w-1/2">
                            <p>{note.content}</p>
                        </div>
                        {/* Open edit form */}
                        {editForm && (
                            <>
                                <form onSubmit={handleSubmit} className="flex flex-col py-4 px-4 bg-gray-200 w-1/2">
                                <label htmlFor="title">Title</label>
                                <input className="h-10 px-2 rounded-md" type="text" name="title" id="title" onChange={(e) => setTitle(e.target.value)} />
                                <label htmlFor="content">Content</label>
                                <textarea className="rounded-md h-12 px-2 py-2" name="content" id="content" onChange={(e) => setContent(e.target.value)} />
                                <div className="py-4 mx-auto">
                                    <button type='submit' className="bg-green-600 text-white rounded-md py-2 px-2 hover:bg-green-700">Update note</button>
                                </div>
                                </form>
                            </>
                        )}
                    </section>
                </>
            ) : (
                <p>Loading...</p>
            )}
        </>
    )
}

export default NotePage
