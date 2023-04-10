package com.prasannjeet.notenirvana.service;

import static java.time.ZoneOffset.UTC;
import static java.util.UUID.fromString;
import static org.openapitools.jackson.nullable.JsonNullable.of;

import com.prasannjeet.notenirvana.exception.UserNotFoundException;
import com.prasannjeet.notenirvana.jpa.entity.NoteEntity;
import com.prasannjeet.notenirvana.model.CreateNoteRequest;
import com.prasannjeet.notenirvana.model.Note;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;

public class NotesApiDelegateUtil {
  public static String getUserName() {
    var token = getToken();
    return (String) token.getTokenAttributes().get("name");
  }

  public static String getUserEmail() {
    var token = getToken();
    return (String) token.getTokenAttributes().get("email");
  }

  public boolean hasUserRole() {
    Collection<GrantedAuthority> authorities = getToken().getAuthorities();
    return authorities.contains(new SimpleGrantedAuthority("ROLE_USER"));
  }

  public static List<String> getAllUserRoles() {
    Collection<GrantedAuthority> authorities = getToken().getAuthorities();
    return authorities.stream().map(GrantedAuthority::getAuthority).toList();
  }

  public static LocalDateTime convertOffsetDateTimeToDateTime(String offsetDateTime) {
    return LocalDateTime.parse(offsetDateTime);
  }

  public static NoteEntity convertNoteToNoteEntity(Note note) {
    NoteEntity noteEntity = new NoteEntity(getUserEmail(), note.getTitle(), note.getContent());
    noteEntity.setId(note.getId().orElse(null).toString());
    return noteEntity;
  }

  public static NoteEntity convertCreateNoteRequestToNoteEntity(CreateNoteRequest note) {
    return new NoteEntity(getUserEmail(), note.getTitle(), note.getContent());
  }

  public static Note createNote(String title, String content) {
    return new Note(title, content);
  }

  public static Note convertNoteEntityToNote(NoteEntity noteEntity) {
    if (noteEntity == null) {
      return null;
    }

    Note note = new Note(noteEntity.getTitle(), noteEntity.getContent());
    note.setId(of(fromString(noteEntity.getId())));
    note.setCreatedAt(of(noteEntity.getCreatedAt().atOffset(UTC)));
    note.setUpdatedAt(of(noteEntity.getUpdatedAt().atOffset(UTC)));

    return note;
  }

  private static JwtAuthenticationToken getToken() {
    try {
      Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
      return (JwtAuthenticationToken) authentication;
    } catch (Exception e) {
      throw new UserNotFoundException("User not found");
    }
  }
}
