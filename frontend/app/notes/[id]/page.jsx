const note = {
    id: 1,
    title: 'title',
    content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
}

const NotePage = async () => {
  return (
    <div className="w-full">
      <section className="flex flex-col justify-center content-center items-center w-1/2 mx-auto">
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
