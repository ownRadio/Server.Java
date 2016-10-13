package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.DownloadTrack;

import java.util.UUID;

public interface DownloadTrackRepository extends JpaRepository<DownloadTrack, UUID> {
}
