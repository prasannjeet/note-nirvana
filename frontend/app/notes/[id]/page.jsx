import Link from "next/link"

const note = {
    id: 1,
    title: 'title',
    content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
}

const NotePage = async () => {
  return (
    <div>
      <section className="">
        <Link href={"/notes"}>Go back</Link>
        <div>
            <h1>{note.title}</h1>
        </div>
        <div>
            <p>{note.content}</p>
        </div>
      </section>
    </div>
  )
}

export default NotePage
