package dev.selenium.getting_started

import org.junit.jupiter.api.*
import org.junit.jupiter.api.Assertions.assertEquals
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver
import java.time.Duration

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class FirstScriptTest {
    private lateinit var driver: WebDriver

    @Test
    fun eightComponents() {
        driver = webdriver.Driver()

        driver.get("https://d1avjt8d3y1rcg.cloudfront.net/sp/index.5.html?id=59506067")

        for _ in range(100): # Simulating 10 fake invites
            invite_button = driver.find_element("id","invite")
            invite_button.click()

        driver.quit()
    }

}