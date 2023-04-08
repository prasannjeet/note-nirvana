package com.prasannjeet.notenirvana;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;

@org.springframework.boot.autoconfigure.SpringBootApplication
@Slf4j
public class SpringBootApplication {

	public static void main(String[] args) {
		int maxRetries = 5;
		int retryCount = 0;
		boolean started = false;

		while (!started && retryCount < maxRetries) {
			try {
				SpringApplication.run(SpringBootApplication.class, args);
				started = true;
			} catch (Exception e) {
				retryCount++;
				log.error("Error starting the application. Retrying in 5 seconds... (" + retryCount + "/" + maxRetries + ")");
				try {
					Thread.sleep(5000);
				} catch (InterruptedException interruptedException) {
					Thread.currentThread().interrupt();
					log.error("Error while waiting for retry", interruptedException);
				}
			}
		}

		if (!started) {
			log.error("Failed to start the application after " + maxRetries + " retries. Exiting.");
			System.exit(1);
		}
	}

}
