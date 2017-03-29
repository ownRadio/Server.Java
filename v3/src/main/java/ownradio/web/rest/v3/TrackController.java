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
import ownradio.domain.DownloadTrack;
import ownradio.domain.NextTrack;
import ownradio.domain.Track;
import ownradio.repository.DownloadTrackRepository;
import ownradio.repository.TrackRepository;
import ownradio.service.TrackService;
import ownradio.util.ResourceUtil;

import java.io.File;
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
	private final DownloadTrackRepository downloadTrackRepository;

	@Autowired
	public TrackController(TrackService trackService, TrackRepository trackRepository, DownloadTrackRepository downloadTrackRepository) {
		this.trackService = trackService;
		this.trackRepository = trackRepository;
		this.downloadTrackRepository = downloadTrackRepository;
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
			trackService.setTrackInfo(trackDTO.getTrack().getRecid());
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
		NextTrack nextTrack = null;
		try {
			nextTrack = trackService.getNextTrackIdV2(deviceId);
		}catch (Exception ex){

		}

		Map<String, String> trackInfo = new HashMap<>();
		if (nextTrack != null) {
			try {
				Track track = trackRepository.findOne(nextTrack.getTrackid());
				//Сохраняем информацию об отданном треке
//				Device device = new Device();
//				device.setRecid(deviceId);
//				DownloadTrack downloadTrack = new DownloadTrack();
//				downloadTrack.setTrack(track);
//				downloadTrack.setDevice(device);
//				downloadTrack.setMethodid(nextTrack.getMethodid());
//				downloadTrack.setUserrecommend(nextTrack.getUseridrecommended());
//				downloadTrack.setTxtrecommendinfo(nextTrack.getTxtrecommendedinfo());
//				downloadTrackRepository.saveAndFlush(downloadTrack);

				File file = new File(track.getPath());
				if(!file.exists()){
					track.setIsexist(0);
					trackRepository.saveAndFlush(track);
					return getNextTrack(deviceId);
				}

				if(track.getIsfilledinfo() == null || track.getIsfilledinfo() != 1)
					trackService.setTrackInfo(track.getRecid());

				if(track.getIscensorial() != null && track.getIscensorial() == 0)
					return getNextTrack(deviceId);
				if(track.getLength() <  120)
					return getNextTrack(deviceId);

				trackInfo.put("id", nextTrack.getTrackid().toString());
				trackInfo.put("length", String.valueOf(track.getLength()));
				if(track.getRecname() != null && !track.getRecname().isEmpty() && !track.getRecname().equals("null"))
					trackInfo.put("name", track.getRecname());
				else
					trackInfo.put("name", "Unknown track");
				if(track.getArtist() != null && !track.getArtist().isEmpty() && !track.getArtist().equals("null"))
					trackInfo.put("artist", track.getArtist());
				else
					trackInfo.put("artist", "Unknown artist");
				trackInfo.put("methodid", nextTrack.getMethodid().toString());

				log.info("getNextTrack return {} {}", nextTrack.getMethodid().toString(), trackInfo.get("id"));
				return new ResponseEntity<>(trackInfo, HttpStatus.OK);
			}catch (Exception ex){
				log.info("{}", ex.getMessage());
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}
}