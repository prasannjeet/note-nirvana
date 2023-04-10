package com.prasannjeet.notenirvana.model.util;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import java.io.IOException;
import java.util.UUID;
import org.openapitools.jackson.nullable.JsonNullable;

public class JsonNullableUUIDDeserializer extends JsonDeserializer<JsonNullable<UUID>> {

  @Override
  public JsonNullable<UUID> deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException {
    String uuidString = jsonParser.getValueAsString();
    UUID uuid = UUID.fromString(uuidString);
    return JsonNullable.of(uuid);
  }
}

