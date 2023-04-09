import { NextResponse } from 'next/server';
import notes from './data.json'

export async function GET(request) {
    return NextResponse.json(notes)
}