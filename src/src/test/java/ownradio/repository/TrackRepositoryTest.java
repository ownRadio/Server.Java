package ownradio.repository;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import ownradio.domain.Track;
import ownradio.domain.User;

import java.util.HashSet;
import java.util.Set;

import static org.junit.Assert.assertTrue;

@ActiveProfiles("prod")
@RunWith(SpringRunner.class)
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class TrackRepositoryTest {
	@Autowired
	private TrackRepository trackRepository;

	@Autowired
	private TestEntityManager entityManager;

	private User user;

	@Before
	public void setUp() throws Exception {
		user = entityManager.persist(new User());
		entityManager.persist(new Track("1", user, "1"));
		entityManager.persist(new Track("2", user, "1"));
		entityManager.persist(new Track("4", user, "1"));
	}

	@Test
	public void getRandomTrackByUserId() throws Exception {
		Set<Track> trackSet = new HashSet<>();

		for (int i = 0; i < 3; i++) {
			Track track = trackRepository.getNextTrackId(user.getId());
			trackSet.add(track);
		}

		assertTrue(trackSet.size() > 1);
	}

}