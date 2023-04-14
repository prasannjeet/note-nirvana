'use client'

import Link from 'next/link'
import {useEffect, useState} from "react";
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";

interface MyNote {
    id: string;
    title: string;
    content: string;
    createdAt: number;
    updatedAt: number;
}

const NotesPage = () => {
    const [notes, setNotes] = useState<MyNote[]>([]);
    const { token, authenticated } = useNextKeycloakAuth();

    useEffect(() => {
        const fetchNotes = async () => {
            if (authenticated) {
                const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/notes`, {
                    headers: {
                        Accept: "application/json",
                        Authorization: `Bearer ${token}`,
                    },
                });
                const data = await res.json();
                setNotes(data);
            } else {
                alert("User is not authenticated. Login first to fetch your notes.");
            }
        };

        fetchNotes().catch((err) => {
            alert("Error fetching notes, or no notes exist. Please try again later. Check console for error.")
            console.log(err)
        });
    }, [token, authenticated]);

    const formatDate = (timestamp: number) => {
        const date = new Date(timestamp * 1000);
        return `${date.getDate()} ${date.toLocaleString("default", { month: "long" })}`;
    };

    return (
        <div className="grid grid-cols-4">
            {notes.map((note) => (
                <Link className="py-2 px-2" key={note.id} href={`/notes/${note.id}`}>
                    <div className="bg-gray-400 py-2 px-2">
            <span className="text-gray-600 font-poppins text-sm py-4">
              {formatDate(note.createdAt)}
            </span>
                        <h2 className="font-bold capitalize text-white">{note.title}</h2>
                        <p className="text-white">{note.content}</p>
                    </div>
                </Link>
            ))}
        </div>
    );
};

export default NotesPage;
