package com.prasannjeet.notenirvana.generated;

import com.prasannjeet.notenirvana.model.CreateNoteRequest;
import com.prasannjeet.notenirvana.model.Error;
import com.prasannjeet.notenirvana.model.Note;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.annotation.Generated;

/**
 * A delegate to be called by the {@link NotesApiController}}.
 * Implement this interface with a {@link org.springframework.stereotype.Service} annotated class.
 */
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2023-04-13T21:58:15.910628+02:00[Europe/Stockholm]")
public interface NotesApiDelegate {

    default Optional<NativeWebRequest> getRequest() {
        return Optional.empty();
    }

    /**
     * POST /notes : Create a new note
     *
     * @param authorization Bearer token for authentication (required)
     * @param createNoteRequest  (required)
     * @return Note created (status code 201)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     * @see NotesApi#createNote
     */
    default ResponseEntity<Note> createNote(String authorization,
        CreateNoteRequest createNoteRequest) {
        getRequest().ifPresent(request -> {
            for (MediaType mediaType: MediaType.parseMediaTypes(request.getHeader("Accept"))) {
                if (mediaType.isCompatibleWith(MediaType.valueOf("application/json"))) {
                    String exampleString = "{ \"createdAt\" : \"2000-01-23T04:56:07.000+00:00\", \"id\" : \"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"title\" : \"title\", \"content\" : \"content\", \"updatedAt\" : \"2000-01-23T04:56:07.000+00:00\" }";
                    ApiUtil.setExampleResponse(request, "application/json", exampleString);
                    break;
                }
            }
        });
        return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);

    }

    /**
     * DELETE /notes/{noteId} : Delete a note by ID
     *
     * @param noteId  (required)
     * @param authorization Bearer token for authentication (required)
     * @return Note deleted (status code 204)
     *         or Unauthorized (status code 401)
     *         or Note not found (status code 404)
     * @see NotesApi#deleteNote
     */
    default ResponseEntity<Void> deleteNote(UUID noteId,
        String authorization) {
        return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);

    }

    /**
     * GET /notes/{noteId} : Retrieve a note by ID
     *
     * @param noteId  (required)
     * @param authorization Bearer token for authentication (required)
     * @return A single note (status code 200)
     *         or Unauthorized (status code 401)
     *         or Note not found (status code 404)
     * @see NotesApi#getNoteById
     */
    default ResponseEntity<Note> getNoteById(UUID noteId,
        String authorization) {
        getRequest().ifPresent(request -> {
            for (MediaType mediaType: MediaType.parseMediaTypes(request.getHeader("Accept"))) {
                if (mediaType.isCompatibleWith(MediaType.valueOf("application/json"))) {
                    String exampleString = "{ \"createdAt\" : \"2000-01-23T04:56:07.000+00:00\", \"id\" : \"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"title\" : \"title\", \"content\" : \"content\", \"updatedAt\" : \"2000-01-23T04:56:07.000+00:00\" }";
                    ApiUtil.setExampleResponse(request, "application/json", exampleString);
                    break;
                }
            }
        });
        return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);

    }

    /**
     * GET /notes : Retrieve all notes for the user
     *
     * @param authorization Bearer token for authentication (required)
     * @return A list of notes (status code 200)
     *         or Unauthorized (status code 401)
     * @see NotesApi#getNotes
     */
    default ResponseEntity<List<Note>> getNotes(String authorization) {
        getRequest().ifPresent(request -> {
            for (MediaType mediaType: MediaType.parseMediaTypes(request.getHeader("Accept"))) {
                if (mediaType.isCompatibleWith(MediaType.valueOf("application/json"))) {
                    String exampleString = "[ { \"createdAt\" : \"2000-01-23T04:56:07.000+00:00\", \"id\" : \"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"title\" : \"title\", \"content\" : \"content\", \"updatedAt\" : \"2000-01-23T04:56:07.000+00:00\" }, { \"createdAt\" : \"2000-01-23T04:56:07.000+00:00\", \"id\" : \"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"title\" : \"title\", \"content\" : \"content\", \"updatedAt\" : \"2000-01-23T04:56:07.000+00:00\" } ]";
                    ApiUtil.setExampleResponse(request, "application/json", exampleString);
                    break;
                }
            }
        });
        return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);

    }

    /**
     * PUT /notes/{noteId} : Update a note by ID
     *
     * @param noteId  (required)
     * @param authorization Bearer token for authentication (required)
     * @param createNoteRequest  (required)
     * @return Note updated (status code 200)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     *         or Note not found (status code 404)
     * @see NotesApi#updateNote
     */
    default ResponseEntity<Note> updateNote(UUID noteId,
        String authorization,
        CreateNoteRequest createNoteRequest) {
        getRequest().ifPresent(request -> {
            for (MediaType mediaType: MediaType.parseMediaTypes(request.getHeader("Accept"))) {
                if (mediaType.isCompatibleWith(MediaType.valueOf("application/json"))) {
                    String exampleString = "{ \"createdAt\" : \"2000-01-23T04:56:07.000+00:00\", \"id\" : \"046b6c7f-0b8a-43b9-b35d-6489e6daee91\", \"title\" : \"title\", \"content\" : \"content\", \"updatedAt\" : \"2000-01-23T04:56:07.000+00:00\" }";
                    ApiUtil.setExampleResponse(request, "application/json", exampleString);
                    break;
                }
            }
        });
        return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);

    }

}
