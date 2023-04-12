'use client'

import {useState, useEffect} from 'react'
import Link from "next/link"
import { FaArrowLeft, FaEdit, FaTrash } from "react-icons/fa"
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";


const NotePage = async ({params: {id}}) => {
    const [note, setNote] = useState();

    const { token, authenticated } = useNextKeycloakAuth();

    console.log(id)
    
    useEffect(() => {
        const fetchNote = async () => {
            if (authenticated) {
                const res = await fetch(`https://nirvana.ooguy.com/api/v1/notes/${id}`, {
                headers: {
                    Accept: "application/json",
                    Authorization: `Bearer ${token}`,
                },
            })
            const data = await res.json();
                console.log("DATA",data)
                setNote(data);
            } else {
                console.log("error")
            }
        }
        console.log(note)
        fetchNote().catch((err) => {
            alert("Error fetching notes, or no notes exist. Please try again later. Check console for error.")
            console.log(err)
        });
    },[token, authenticated])




    return (
        <>

            {/* <div className="mx-4 my-4 flex justify-between">
                <Link className="py-4 px-4 bg-gray-400 rounded-md text-white" href={"/notes"}>
                    <FaArrowLeft />
                </Link>
                <div className="flex">
                    <FaTrash className="mr-4" />
                    <FaEdit />
                </div>
            </div>
            <section className="flex flex-col justify-center content-center items-center">
                <div>
                    <h1>{note.title}</h1>
                </div>
                <div className="w-1/2">
                    <p>{note.content}</p>
                </div>
            </section> */}
        </>
    )
}

export default NotePage
