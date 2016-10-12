package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.DownloadTrack;

public interface DownloadTrackRepository extends JpaRepository<DownloadTrack, String> {
}
