import Link from 'next/link'

async function fetchNotes() {
    const res = await fetch('/api/notes', {
        next: {
            revalidate: 60
        }
    })
    const data = await res.json()
    return data
}

const NotesPage = async () => {
    const notes = await fetchNotes()
  return (
    <div className="grid">
      {
        notes.map((note) => (
          <Link key={note.id} href={`/notes/${note.id}`}>
              <div className="card">
                <h2>{note.title}</h2>
                <p>{note.content}</p>
              </div>
          </Link>
        ))
      }
    </div>
  )
}

export default NotesPage
