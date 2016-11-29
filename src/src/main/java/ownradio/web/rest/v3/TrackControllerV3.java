package ownradio.web.rest.v3;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ownradio.domain.Device;
import ownradio.domain.NextTrack;
import ownradio.domain.Track;
import ownradio.repository.TrackRepository;
import ownradio.service.TrackService;
import ownradio.util.ResourceUtil;

import java.util.*;

/**
 * Created by a.polunina on 28.11.2016.
 */
@Slf4j
@RestController
@RequestMapping(value = "/v3/tracks")
public class TrackControllerV3 {

	private final TrackService trackService;
	private final TrackRepository trackRepository;

	@Autowired
	public TrackControllerV3(TrackService trackService, TrackRepository trackRepository) {
		this.trackService = trackService;
		this.trackRepository = trackRepository;
	}

	@Data
	private static class TrackDTO {
		private UUID fileGuid;
		private String fileName;
		private String filePath;
		private UUID deviceId;
		private MultipartFile musicFile;

		public Track getTrack() {
			Device device = new Device();
			device.setRecid(deviceId);

			Track track = new Track();
			track.setRecid(fileGuid);
			track.setRecname(fileName);
			track.setDevice(device);
			track.setPath("---");
			track.setLocaldevicepathupload(filePath);

			return track;
		}
	}

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity save(ownradio.web.rest.v3.TrackControllerV3.TrackDTO trackDTO) {
		if (trackDTO.getMusicFile().isEmpty()) {
			return new ResponseEntity(HttpStatus.BAD_REQUEST);
		}

		try {
			trackService.save(trackDTO.getTrack(), trackDTO.getMusicFile());

			return new ResponseEntity(HttpStatus.CREATED);
		} catch (Exception e) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<?> getTrack(@PathVariable UUID id) {
		Track track = trackService.getById(id);

		if (track != null) {
			byte[] bytes = ResourceUtil.read(track.getPath());
			return new ResponseEntity<>(bytes, getHttpAudioHeaders(), HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	private HttpHeaders getHttpAudioHeaders() {
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "audio/mpeg");
		return responseHeaders;
	}

	@RequestMapping(value = "/{deviceId}/next", method = RequestMethod.GET)
	public ResponseEntity<?> getNextTrack(@PathVariable UUID deviceId) {
		NextTrack nextTrack = trackService.getNextTrackIdV2(deviceId);
		UUID trackId = nextTrack.getTrackid();

		if (trackId != null) {
			Track track = trackRepository.findOne(trackId);
			log.info("{} {} {}", track.getRecname(), track.getArtist(), track.getLength());
			Map<String, String> trackInfo = new HashMap<>();
			trackInfo.put("id", trackId.toString());
			trackInfo.put("length", String.valueOf(track.getLength()));
			trackInfo.put("name", track.getRecname());
			trackInfo.put("artist", track.getArtist());
			trackInfo.put("methodid", nextTrack.getMethodid().toString());
			return new ResponseEntity<>(trackInfo, HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

}