package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ownradio.domain.Track;

public interface TrackRepository extends JpaRepository<Track, String> {
	@Query(value = "select * from random_track(?1)", nativeQuery = true)
	Track getRandomTrackByUserId(String userId);
}
