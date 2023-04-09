'use client'

import Link from "next/link"
import { useState, useEffect } from "react"

const Navbar =  () => {
    const [notes, setNotes] = useState([])
    const [loading, setLoading] = useState(true)

    
    useEffect(() => {
        const fetchNotes = async () => {
            const res = await fetch('/api/notes');
            const data = await res.json();
            setNotes(data);
            setLoading(false);
          };
      
          fetchNotes();
    },[])

  return (
    <header className="top-0 left-0 w-[22vw] bg-blue-600  p-10 pl-10 text-white fixed h-full sm:w-[25vw]">
      <div>
        <div>
            <Link href={"/"}>
                Nirvana notes
            </Link>
        </div>
        {
            <div className="mt-4">
          {notes.map((note) => (
                <div key={note.id} className="mt-2">
                  <Link href={`/notes/${note.id}`}>
                      {note.title}
                  </Link>
                </div>

              ))}
              </div>
        }
      </div>
    </header>
  )
}

export default Navbar
