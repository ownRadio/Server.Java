package ownradio.web.rest.v2;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import ownradio.domain.Track;
import ownradio.domain.User;
import ownradio.service.TrackService;
import ownradio.service.UserService;
import ownradio.util.ResourceUtil;

import java.io.File;
import java.util.UUID;

import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.fileUpload;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static ownradio.util.ResourceUtil.UPLOAD_DIR;

@RunWith(SpringRunner.class)
@WebMvcTest(TrackController.class)
public class TrackControllerTest {
	public static final UUID TRACK_UUID = UUID.randomUUID();
	public static final UUID USER_UUID = UUID.randomUUID();
	public static final UUID DEVICE_UUID = UUID.randomUUID();
	public static final String FILE = TRACK_UUID + ".mp3";
	public static final String PATH = UPLOAD_DIR + USER_UUID + "/" + FILE;

	@MockBean
	private TrackService trackService;

	@MockBean
	private UserService userService;

	@Autowired
	protected MockMvc mockMvc;

	private MockMultipartFile correctFile;
	private MockMultipartFile emptyFile;

	private ObjectMapper mapper = new ObjectMapper();

	private User uploadUser = new User();
	private Track track;

	@Before
	public void setUp() throws Exception {
		uploadUser.setId(USER_UUID);
		track = new Track(PATH, uploadUser, "---");

		String requestParam = "file";
		String originalFilename = "test.mp3";
		String contentType = "text/plain";

		correctFile = new MockMultipartFile(requestParam, originalFilename, contentType, "Text".getBytes());
		emptyFile = new MockMultipartFile(requestParam, originalFilename, contentType, "".getBytes());

		ResourceUtil.save(USER_UUID.toString(), FILE, correctFile);
	}

	@After
	public void tearDown() throws Exception {
		FileUtils.deleteDirectory(new File(UPLOAD_DIR));
	}

	@Test
	public void saveStatusIsOk() throws Exception {
		given(this.userService.getById(USER_UUID)).willReturn(uploadUser);

		mockMvc.perform(fileUpload("/api/v2/tracks")
				.file(correctFile)
				.accept(MediaType.APPLICATION_JSON_UTF8_VALUE)
				.param("path", track.getPath())
				.param("uploadUser", USER_UUID.toString())
				.param("localDevicePathUpload", track.getLocalDevicePathUpload())
		)
				.andExpect(
						status().isCreated()
				);

		verify(this.userService).getById(USER_UUID);
	}

	@Test
	public void saveStatusIsBadRequest() throws Exception {
		mockMvc.perform(fileUpload("/api/v2/tracks")
				.file(emptyFile)
				.accept(MediaType.APPLICATION_JSON_UTF8_VALUE)
				.param("path", track.getPath())
				.param("uploadUser", USER_UUID.toString())
				.param("localDevicePathUpload", track.getLocalDevicePathUpload())
		)
				.andExpect(
						status().isBadRequest()
				);
	}

	@Test
	public void getTrackStatusIsOk() throws Exception {
		given(this.trackService.getById(TRACK_UUID)).willReturn(track);

		mockMvc.perform(get("/api/v2/tracks/" + TRACK_UUID).accept(MediaType.TEXT_PLAIN))
				.andExpect(
						status().isOk()
				)
				.andExpect(
						content().string("Text")
				);
	}

	@Test
	public void getTrackStatusIsNotFound() throws Exception {

		given(this.trackService.getById(TRACK_UUID)).willReturn(null);

		mockMvc.perform(get("/api/v2/tracks/" + TRACK_UUID).accept(MediaType.TEXT_PLAIN))
				.andExpect(
						status().isNotFound()
				);
	}

	@Test
	public void getNextTrackIdIsOk() throws Exception {
		given(this.trackService.getNextTrackId(DEVICE_UUID)).willReturn(TRACK_UUID);

		mockMvc.perform(get("/api/v2/tracks/" + DEVICE_UUID + "/next"))
				.andExpect(
						status().isOk()
				)
				.andExpect(
						content().string(mapper.writeValueAsString(TRACK_UUID))
				);

	}

	@Test
	public void getNextTrackIdIsNotFound() throws Exception {
		given(this.trackService.getNextTrackId(DEVICE_UUID)).willReturn(null);

		mockMvc.perform(get("/api/v2/tracks/" + DEVICE_UUID + "/next"))
				.andExpect(
						status().isNotFound()
				);

	}

}