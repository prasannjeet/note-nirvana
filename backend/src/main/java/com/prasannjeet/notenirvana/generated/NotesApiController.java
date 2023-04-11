package com.prasannjeet.notenirvana.generated;

import com.prasannjeet.notenirvana.model.CreateNoteRequest;
import com.prasannjeet.notenirvana.model.Error;
import com.prasannjeet.notenirvana.model.Note;
import java.util.UUID;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.*;
import javax.validation.Valid;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.annotation.Generated;

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2023-04-11T15:05:04.035681+02:00[Europe/Stockholm]")
@Controller
@RequestMapping("${openapi.noteTakingApp.base-path:/v1}")
public class NotesApiController implements NotesApi {

    private final NotesApiDelegate delegate;

    public NotesApiController(@Autowired(required = false) NotesApiDelegate delegate) {
        this.delegate = Optional.ofNullable(delegate).orElse(new NotesApiDelegate() {});
    }

    @Override
    public NotesApiDelegate getDelegate() {
        return delegate;
    }

}
