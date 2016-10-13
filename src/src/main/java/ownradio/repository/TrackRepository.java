package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import ownradio.domain.Track;

import java.util.UUID;

public interface TrackRepository extends JpaRepository<Track, UUID> {
	@Query(value = "select * from getnexttrackid(?1)", nativeQuery = true)
	Track getNextTrackId(UUID deviceId);
}
