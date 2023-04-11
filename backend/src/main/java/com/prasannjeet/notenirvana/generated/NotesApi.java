/**
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech) (6.5.0).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */
package com.prasannjeet.notenirvana.generated;

import com.prasannjeet.notenirvana.model.CreateNoteRequest;
import com.prasannjeet.notenirvana.model.Error;
import com.prasannjeet.notenirvana.model.Note;
import java.util.UUID;
import io.swagger.v3.oas.annotations.ExternalDocumentation;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import javax.validation.constraints.*;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2023-04-11T15:05:04.035681+02:00[Europe/Stockholm]")
@Validated
@Controller
@Tag(name = "notes", description = "the notes API")
public interface NotesApi {

    default NotesApiDelegate getDelegate() {
        return new NotesApiDelegate() {};
    }

    /**
     * POST /notes : Create a new note
     *
     * @param authorization Bearer token for authentication (required)
     * @param createNoteRequest  (required)
     * @return Note created (status code 201)
     *         or Bad Request (status code 400)
     *         or Unauthorized (status code 401)
     */
    @Operation(
        operationId = "createNote",
        summary = "Create a new note",
        responses = {
            @ApiResponse(responseCode = "201", description = "Note created", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Note.class))
            }),
            @ApiResponse(responseCode = "400", description = "Bad Request", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            }),
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            })
        },
        security = {
            @SecurityRequirement(name = "BearerAuth")
        }
    )
    @RequestMapping(
        method = RequestMethod.POST,
        value = "/notes",
        produces = { "application/json" },
        consumes = { "application/json" }
    )
    default ResponseEntity<Note> createNote(
        @NotNull @Parameter(name = "Authorization", description = "Bearer token for authentication", required = true, in = ParameterIn.HEADER) @RequestHeader(value = "Authorization", required = true) String authorization,
        @Parameter(name = "CreateNoteRequest", description = "", required = true) @Valid @RequestBody CreateNoteRequest createNoteRequest
    ) {
        return getDelegate().createNote(authorization, createNoteRequest);
    }


    /**
     * DELETE /notes/{noteId} : Delete a note by ID
     *
     * @param noteId  (required)
     * @param authorization Bearer token for authentication (required)
     * @return Note deleted (status code 204)
     *         or Unauthorized (status code 401)
     *         or Note not found (status code 404)
     */
    @Operation(
        operationId = "deleteNote",
        summary = "Delete a note by ID",
        responses = {
            @ApiResponse(responseCode = "204", description = "Note deleted"),
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            }),
            @ApiResponse(responseCode = "404", description = "Note not found", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            })
        },
        security = {
            @SecurityRequirement(name = "BearerAuth")
        }
    )
    @RequestMapping(
        method = RequestMethod.DELETE,
        value = "/notes/{noteId}",
        produces = { "application/json" }
    )
    default ResponseEntity<Void> deleteNote(
        @Parameter(name = "noteId", description = "", required = true, in = ParameterIn.PATH) @PathVariable("noteId") UUID noteId,
        @NotNull @Parameter(name = "Authorization", description = "Bearer token for authentication", required = true, in = ParameterIn.HEADER) @RequestHeader(value = "Authorization", required = true) String authorization
    ) {
        return getDelegate().deleteNote(noteId, authorization);
    }


    /**
     * GET /notes/{noteId} : Retrieve a note by ID
     *
     * @param noteId  (required)
     * @param authorization Bearer token for authentication (required)
     * @return A single note (status code 200)
     *         or Unauthorized (status code 401)
     *         or Note not found (status code 404)
     */
    @Operation(
        operationId = "getNoteById",
        summary = "Retrieve a note by ID",
        responses = {
            @ApiResponse(responseCode = "200", description = "A single note", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Note.class))
            }),
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            }),
            @ApiResponse(responseCode = "404", description = "Note not found", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            })
        },
        security = {
            @SecurityRequirement(name = "BearerAuth")
        }
    )
    @RequestMapping(
        method = RequestMethod.GET,
        value = "/notes/{noteId}",
        produces = { "application/json" }
    )
    default ResponseEntity<Note> getNoteById(
        @Parameter(name = "noteId", description = "", required = true, in = ParameterIn.PATH) @PathVariable("noteId") UUID noteId,
        @NotNull @Parameter(name = "Authorization", description = "Bearer token for authentication", required = true, in = ParameterIn.HEADER) @RequestHeader(value = "Authorization", required = true) String authorization
    ) {
        return getDelegate().getNoteById(noteId, authorization);
    }


    /**
     * GET /notes : Retrieve all notes for the user
     *
     * @param authorization Bearer token for authentication (required)
     * @return A list of notes (status code 200)
     *         or Unauthorized (status code 401)
     */
    @Operation(
        operationId = "getNotes",
        summary = "Retrieve all notes for the user",
        responses = {
            @ApiResponse(responseCode = "200", description = "A list of notes", content = {
                @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = Note.class)))
            }),
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            })
        },
        security = {
            @SecurityRequirement(name = "BearerAuth")
        }
    )
    @RequestMapping(
        method = RequestMethod.GET,
        value = "/notes",
        produces = { "application/json" }
    )
    default ResponseEntity<List<Note>> getNotes(
        @NotNull @Parameter(name = "Authorization", description = "Bearer token for authentication", required = true, in = ParameterIn.HEADER) @RequestHeader(value = "Authorization", required = true) String authorization
    ) {
        return getDelegate().getNotes(authorization);
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
     */
    @Operation(
        operationId = "updateNote",
        summary = "Update a note by ID",
        responses = {
            @ApiResponse(responseCode = "200", description = "Note updated", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Note.class))
            }),
            @ApiResponse(responseCode = "400", description = "Bad Request", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            }),
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            }),
            @ApiResponse(responseCode = "404", description = "Note not found", content = {
                @Content(mediaType = "application/json", schema = @Schema(implementation = Error.class))
            })
        },
        security = {
            @SecurityRequirement(name = "BearerAuth")
        }
    )
    @RequestMapping(
        method = RequestMethod.PUT,
        value = "/notes/{noteId}",
        produces = { "application/json" },
        consumes = { "application/json" }
    )
    default ResponseEntity<Note> updateNote(
        @Parameter(name = "noteId", description = "", required = true, in = ParameterIn.PATH) @PathVariable("noteId") UUID noteId,
        @NotNull @Parameter(name = "Authorization", description = "Bearer token for authentication", required = true, in = ParameterIn.HEADER) @RequestHeader(value = "Authorization", required = true) String authorization,
        @Parameter(name = "CreateNoteRequest", description = "", required = true) @Valid @RequestBody CreateNoteRequest createNoteRequest
    ) {
        return getDelegate().updateNote(noteId, authorization, createNoteRequest);
    }

}
