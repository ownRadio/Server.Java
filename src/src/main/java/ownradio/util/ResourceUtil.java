package ownradio.util;

import org.springframework.util.ResourceUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.ResourceBundle;

public class ResourceUtil {
	public static final String USER_DIR = System.getProperty("user.dir");
	public static final String UPLOADING_DIR = USER_DIR + "/userfile/";
	public static final String MESSAGE_DIR = USER_DIR + "/msg";
	public static final String MESSAGE_BASE_NAME = "masseage";

	private ResourceUtil() {
	}

	public static byte[] read(String fileName) {
		File file;
		try {
			file = ResourceUtils.getFile(fileName);
			return Files.readAllBytes(file.toPath());
		} catch (IOException e) {
			throw new RuntimeException("Error read resource");
		}
	}

	public static String save(String userDir, String fileName, MultipartFile file) {
		try {
			File dir = new File(UPLOADING_DIR + userDir);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			String filePath = Paths.get(UPLOADING_DIR, userDir, fileName).toString();
			file.transferTo(new File(filePath));

			return filePath;
		} catch (Exception e) {
			throw new RuntimeException("Error save file", e);
		}
	}

	public static ResourceBundle getResourceBundle() {
		File file = new File(MESSAGE_DIR);
		URL[] urls;
		try {
			urls = new URL[]{file.toURI().toURL()};
		} catch (MalformedURLException e) {
			throw new RuntimeException(e);
		}
		ClassLoader loader = new URLClassLoader(urls);

		return ResourceBundle.getBundle(MESSAGE_BASE_NAME, Locale.getDefault(), loader);
	}

}
