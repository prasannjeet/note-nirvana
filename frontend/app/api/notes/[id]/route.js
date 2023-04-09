import { NextResponse } from 'next/server';
import notes from '../data.json'

// Get note by id
export async function GET(request, {params}) {
    const id = params.id
    const parsedId = Number(id)
    const note = notes.find(note => Number(note.id) === parsedId)


    if (note) {
        return NextResponse.json(note)
    } else {
        return NextResponse.notFound()
    }
    
}