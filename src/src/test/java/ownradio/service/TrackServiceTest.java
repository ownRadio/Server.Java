package ownradio.service;

import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.junit4.SpringRunner;
import ownradio.domain.Track;
import ownradio.domain.User;
import ownradio.repository.TrackRepository;
import ownradio.service.impl.TrackServiceImpl;

import java.io.File;
import java.util.UUID;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static org.mockito.BDDMockito.given;
import static ownradio.util.ResourceUtil.UPLOAD_DIR;

@RunWith(SpringRunner.class)
public class TrackServiceTest {
	@Mock
	private TrackRepository trackRepository;

	protected TrackService trackService;

	private UUID userId = UUID.randomUUID();
	private UUID trackId = UUID.randomUUID();
	private Track expected;

	@Before
	public void setUp() throws Exception {
		trackService = new TrackServiceImpl(trackRepository);
		expected = new Track();
		expected.setId(trackId);

		User uploadUser = new User();
		uploadUser.setId(userId);
		expected.setUploadUser(uploadUser);
	}

	@After
	public void tearDown() throws Exception {
		FileUtils.deleteDirectory(new File(UPLOAD_DIR));
	}

	@Test
	public void getNextTrackId() throws Exception {
		given(this.trackRepository.getNextTrackId(trackId)).willReturn(expected);

		UUID actual = trackService.getNextTrackId(trackId);

		assertThat(actual, equalTo(expected.getId()));
	}

	@Test
	public void save() throws Exception {
		MockMultipartFile correctFile = new MockMultipartFile("file", "test.mp3", "text/plain", "Text".getBytes());;

		trackService.save(expected, correctFile);

		assertThat(new File(expected.getPath()).exists(), is(true));
	}

}