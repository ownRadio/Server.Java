package ownradio.service;

import org.springframework.web.multipart.MultipartFile;
import ownradio.domain.Track;

import java.util.UUID;

/**
 * Created by Tanat on 17.10.2016.
 */
public interface TrackService {

	Track getById(UUID id);

	UUID getNextTrackId(UUID deviceId);

	void save(Track track, MultipartFile file);
}
