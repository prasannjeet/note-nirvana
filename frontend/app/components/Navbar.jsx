'use client'
import Link from "next/link"
import { useState, useEffect } from "react"
import {FaPlus} from 'react-icons/fa'

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
    <header className="flex flex-row justify-between py-4">
        <div className="px-4">
            <Link href={"/"} className="font-bold text-lg">
                Nirvana notes
            </Link>
            
        </div>
        <div>
            <ul className="flex flex-row">
                <li className="mx-2">
                    <Link href={"/dashboard"}>Dashboard</Link>
                </li>
                <li className="mx-2">
                    <Link href={"/"}>Profile</Link>
                </li>
            </ul>
        </div>
        <div className="px-3">
        <Link href={"/new"} className="flex cursor-pointer bg-green-600 py-2 px-2 rounded-md text-white" onClick={() => console.log("clicked")}>
                <span>Add note</span> <FaPlus className="mt-1 ml-2" />
            </Link>
        </div>
    </header>
  )
}

export default Navbar
