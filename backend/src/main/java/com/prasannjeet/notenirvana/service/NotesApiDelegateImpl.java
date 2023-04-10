package com.prasannjeet.notenirvana.service;

import static com.prasannjeet.notenirvana.service.NotesApiDelegateUtil.convertCreateNoteRequestToNoteEntity;
import static com.prasannjeet.notenirvana.service.NotesApiDelegateUtil.convertNoteEntityToNote;
import static com.prasannjeet.notenirvana.service.NotesApiDelegateUtil.getUserEmail;
import static org.springframework.http.HttpStatus.CREATED;
import static org.springframework.http.HttpStatus.FORBIDDEN;
import static org.springframework.http.HttpStatus.NOT_FOUND;
import static org.springframework.http.HttpStatus.NO_CONTENT;
import static org.springframework.http.HttpStatus.OK;

import com.prasannjeet.notenirvana.exception.NotAllowedException;
import com.prasannjeet.notenirvana.exception.NoteNotFoundException;
import com.prasannjeet.notenirvana.generated.NotesApiDelegate;
import com.prasannjeet.notenirvana.jpa.entity.NoteEntity;
import com.prasannjeet.notenirvana.jpa.repository.NoteEntityRepository;
import com.prasannjeet.notenirvana.model.CreateNoteRequest;
import com.prasannjeet.notenirvana.model.Note;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.NativeWebRequest;

@Service
@RequiredArgsConstructor
public class NotesApiDelegateImpl implements NotesApiDelegate {

  private final NoteEntityRepository noteEntityRepository;

  @Override
  public Optional<NativeWebRequest> getRequest() {
    return NotesApiDelegate.super.getRequest();
  }

  @Override
  public ResponseEntity<Note> createNote(String authorization, CreateNoteRequest note) {
    NoteEntity noteEntity = convertCreateNoteRequestToNoteEntity(note);
    noteEntityRepository.save(noteEntity);
    return new ResponseEntity<>(convertNoteEntityToNote(noteEntity), CREATED);
  }

  @Override
  public ResponseEntity<Void> deleteNote(UUID noteId, String authorization) {
    try {
      validateUser(noteId);
      noteEntityRepository.deleteById(noteId.toString());
      return new ResponseEntity<>(NO_CONTENT);
    } catch (NoteNotFoundException e) {
      return new ResponseEntity<>(NOT_FOUND);
    } catch (NotAllowedException e) {
      return new ResponseEntity<>(FORBIDDEN);
    }
  }

  @Override
  public ResponseEntity<Note> getNoteById(UUID noteId, String authorization) {
    try {
      NoteEntity noteEntity = validateUser(noteId);
      return new ResponseEntity<>(convertNoteEntityToNote(noteEntity), OK);
    } catch (NoteNotFoundException e) {
      return new ResponseEntity<>(NOT_FOUND);
    } catch (NotAllowedException e) {
      return new ResponseEntity<>(FORBIDDEN);
    }
  }

  @Override
  public ResponseEntity<List<Note>> getNotes(String authorization) {
    List<NoteEntity> allByUserId = noteEntityRepository.findAllByUserId(getUserEmail());
    
    if (allByUserId.isEmpty()) {
      return new ResponseEntity<>(NOT_FOUND);
    }
    
    List<Note> notes = new ArrayList<>();
    for (var item : allByUserId) {
      notes.add(convertNoteEntityToNote(item));
    }
    
    return new ResponseEntity<>(notes, OK);
  }

  @Override
  public ResponseEntity<Note> updateNote(UUID noteId, String authorization, CreateNoteRequest note) {
    try {
      NoteEntity noteEntity = validateUser(noteId);
      noteEntity.setTitle(note.getTitle());
      noteEntity.setContent(note.getContent());
      noteEntityRepository.save(noteEntity);
      return new ResponseEntity<>(convertNoteEntityToNote(noteEntity), OK);
    } catch (NoteNotFoundException e) {
      return new ResponseEntity<>(NOT_FOUND);
    } catch (NotAllowedException e) {
      return new ResponseEntity<>(FORBIDDEN);
    }
  }
  
  private NoteEntity validateUser(UUID noteId) {
    Optional<NoteEntity> byId = noteEntityRepository.findById(noteId.toString());
    if (byId.isEmpty()) {
      throw new NoteNotFoundException("Note not found");
    }
    NoteEntity noteEntity = byId.get();
    String userIdEmail = noteEntity.getUserId();
    String userEmail = getUserEmail();
    if (!userEmail.equals(userIdEmail)) {
      throw new NotAllowedException("Not allowed");
    }
    return noteEntity;
  }
}
