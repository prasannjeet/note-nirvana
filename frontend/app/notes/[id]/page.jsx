import Link from "next/link"
import { FaArrowLeft, FaEdit, FaTrash } from "react-icons/fa"

const note = {
    id: 1,
    title: 'title',
    content: 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Placeat tenetur quasi rerum maiores illo laborum ullam dolores ut perferendis in similique veniam magni ipsam eum, inventore minima repellat quae veritatis!',
}

const NotePage = async () => {
    return (
        <>
            <div className="mx-4 my-4 flex justify-between">
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
            </section>
        </>
    )
}

export default NotePage
