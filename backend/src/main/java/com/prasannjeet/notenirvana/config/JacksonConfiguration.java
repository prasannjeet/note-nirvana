package com.prasannjeet.notenirvana.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.prasannjeet.notenirvana.model.Note;
import com.prasannjeet.notenirvana.model.util.JsonNullableSerializer;
import com.prasannjeet.notenirvana.model.util.NoteMixin;
import org.openapitools.jackson.nullable.JsonNullable;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JacksonConfiguration {

  @Bean
  public ObjectMapper objectMapper() {
    ObjectMapper objectMapper = new ObjectMapper();

    // Register NoteMixin
    objectMapper.addMixIn(Note.class, NoteMixin.class);

    // Register custom JsonNullable serializer
    SimpleModule module = new SimpleModule();
    module.addSerializer((Class<JsonNullable<?>>) (Class<?>) JsonNullable.class, new JsonNullableSerializer());
    objectMapper.registerModule(module);

    // Register JavaTimeModule for Java 8 date/time support
    objectMapper.registerModule(new JavaTimeModule());

    return objectMapper;
  }
}

