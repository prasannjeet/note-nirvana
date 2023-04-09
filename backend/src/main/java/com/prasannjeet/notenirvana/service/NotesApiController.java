package com.prasannjeet.notenirvana.service;

import java.util.Optional;
import javax.annotation.Generated;
import javax.validation.constraints.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Generated(
    value = "org.openapitools.codegen.languages.SpringCodegen",
    date = "2023-04-08T16:34:45.451582+02:00[Europe/Stockholm]")
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
