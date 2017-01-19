package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ownradio.domain.Device;
import ownradio.domain.DownloadTrack;
import ownradio.domain.Track;

import java.util.UUID;

/**
 * Интерфейс репозитория, для хранения истории скаченных треков
 *
 * @author Alpenov Tanat
 */
public interface DownloadTrackRepository extends JpaRepository<DownloadTrack, UUID> {

	DownloadTrack findFirstByDeviceAndTrackOrderByReccreatedAsc(Device device, Track track);

}
