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
    <header className="grid grid-cols-7">
      <aside className="self-start sticky top-0 col-span-1">
        <div className="px-4">
            <Link href={"/"} className="font-bold text-lg">
                Nirvana notes
            </Link>
        </div>
        <div className="px-4 flex-1 overflow-hidden">
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
        
      </aside>
    </header>
  )
}

export default Navbar
