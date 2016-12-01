package ownradio.web.rest.v3;

import com.mpatric.mp3agic.ID3v1;
import com.mpatric.mp3agic.ID3v1Tag;
import com.mpatric.mp3agic.ID3v2;
import com.mpatric.mp3agic.Mp3File;
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

import javax.sound.sampled.*;
import java.io.*;
import java.util.*;

/**
 * Created by a.polunina on 28.11.2016.
 */
@Slf4j
@RestController("TrackControllerV3")
@RequestMapping(value = "/v3/tracks")
public class TrackController {

	private final TrackService trackService;
	private final TrackRepository trackRepository;

	@Autowired
	public TrackController(TrackService trackService, TrackRepository trackRepository) {
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
	public ResponseEntity save(TrackDTO trackDTO) {
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
		Map<String, String> trackInfo = new HashMap<>();

		if (nextTrack.getTrackid() != null) {
			try {
				Track track = trackRepository.findOne(nextTrack.getTrackid());

				if(track.getIsfilledinfo() == null || track.getIsfilledinfo() != 1)
				{
					Mp3File mp3File = new Mp3File(track.getPath());

					track.setLength((int) mp3File.getLengthInSeconds());
					track.setSize((int)mp3File.getLength() / 1024);//size in kilobytes

					if (mp3File.hasId3v1Tag()) {
						ID3v2 id3v2Tag2 = mp3File.getId3v2Tag();
						track.setRecname(id3v2Tag2.getTitle());
						track.setArtist(id3v2Tag2.getArtist());
					}
					track.setIsfilledinfo(1);
					trackRepository.saveAndFlush(track);
				}
				trackInfo.put("id", nextTrack.getTrackid().toString());
				trackInfo.put("length", String.valueOf(track.getLength()));
				trackInfo.put("name", track.getRecname());
				trackInfo.put("artist", track.getArtist());
				trackInfo.put("methodid", nextTrack.getMethodid().toString());

				return new ResponseEntity<>(trackInfo, HttpStatus.OK);
			}catch (Exception ex){
				log.debug("{}", ex.getMessage());
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}
}