package com.prasannjeet.notenirvana.model.util;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import java.io.IOException;
import org.openapitools.jackson.nullable.JsonNullable;

public class JsonNullableSerializer extends JsonSerializer<JsonNullable<?>> {

  @Override
  public void serialize(JsonNullable<?> value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
    if (value.isPresent()) {
      gen.writeObject(value.get());
    } else {
      gen.writeNull();
    }
  }
}

