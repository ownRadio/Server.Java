package ownradio.web.rest.home;

import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Created by a.polunina on 29.08.2017.
 */
@Slf4j
@RestController
@RequestMapping("/")
public class HomeController {

	HomeController(){
	}

	@RequestMapping("/")
	public void getFile(HttpServletResponse response) throws IOException {
		InputStream is = new FileInputStream(getClass().getClassLoader().getResource("static/index.html").getFile());
		IOUtils.copy(is, response.getOutputStream());
		response.flushBuffer();
	}
}
