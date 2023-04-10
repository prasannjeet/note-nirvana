import Link from 'next/link'

const notes = [
    {
        id: 1,
        title: 'title',
        content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
    },
    {
        id: 2,
        title: 'Two',
        content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
    },
    {
        id: 3,
        title: 'Three',
        content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
    },
    {
        id: 4,
        title: 'Four',
        content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
    },
    {
        id: 5,
        title: 'Five',
        content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
    },
]

const NotesPage = async () => {
  return (
    <div className="grid grid-cols-4">
      {
        notes.map((note) => (
          <Link className='py-2 px-2' key={note.id} href={`/notes/${note.id}`}>
              <div className='bg-gray-400 py-2 px-2 text-white'>
                <h2 className='font-bold capitalize'>{note.title}</h2>
                <p>{note.content}</p>
              </div>
          </Link>
        ))
      }
    </div>
  )
}

export default NotesPage
