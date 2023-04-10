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
]

const DashboardPage = async () => {
  return (
    <>
      <h1>Dashboard</h1>
      <ul>
        {
          notes.map((note) => (
            <li key={note.id}>
              <Link href={`/notes/${note.id}`}>
                {note.title}
              </Link>
            </li>
          ))
        }
      </ul>
    </>
  )
}

export default DashboardPage
