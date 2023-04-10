package com.prasannjeet.notenirvana.model.util;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import java.util.UUID;
import org.openapitools.jackson.nullable.JsonNullable;

public abstract class NoteMixin {

  @JsonDeserialize(using = JsonNullableUUIDDeserializer.class)
  private JsonNullable<UUID> id;

}

