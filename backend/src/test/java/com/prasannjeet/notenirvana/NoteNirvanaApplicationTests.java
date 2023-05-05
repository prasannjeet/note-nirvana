package com.prasannjeet.notenirvana;

import com.prasannjeet.notenirvana.config.WebSecurityConfig;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

@SpringBootTest
class NoteNirvanaApplicationTests {

	@MockBean
	private WebSecurityConfig webSecurityConfig;

	@Test
	void contextLoads() {
	}

}
