import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';
import notes from './data.json'

export async function GET(request) {
    return NextResponse.json(notes)
}

export async function POST(request) {
    const body = await request.json()

    const newNote = {
        id: uuidv4(),
        title: body.title,
        content: body.content
    }

    notes.push(newNote);
}


