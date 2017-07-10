package ownradio.web.rest.v5;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ownradio.domain.Device;
import ownradio.domain.Log;
import ownradio.domain.Track;
import ownradio.service.LogService;
import ownradio.service.TrackService;
import ownradio.util.MultipartFileSender;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.UUID;

/**
 * Created by a.polunina on 27.06.2017.
 */
@Slf4j
//@CrossOrigin
@RestController("TrackControllerV5")
@RequestMapping(value = "/v5/tracks")
public class TrackController {
	private final TrackService trackService;
	private final LogService logService;

	public TrackController(TrackService trackService, LogService logService) {
		this.trackService = trackService;
		this.logService = logService;
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
	public ResponseEntity<?> save(TrackController.TrackDTO trackDTO) {
		Log logRec = new Log();
		logRec.setRecname("Upload");
		logRec.setDeviceid(trackDTO.getDeviceId());
		logRec.setLogtext("/v5/tracks; Body: TrackidId=" + trackDTO.getFileGuid() +", fileName=" + trackDTO.getFileName() + ", filePath=" + trackDTO.getFilePath() + ", deviceid=" + trackDTO.getDeviceId() + ", musicFile=" + (trackDTO.getMusicFile() != null ? trackDTO.getMusicFile().getOriginalFilename() : null));
		logService.save(logRec);
		if(trackService.getById(trackDTO.getTrack().getRecid()) != null){
			logRec.setResponse("Http.Status=" + HttpStatus.CONFLICT + "; This uuid already exist!");
			logService.save(logRec);
			return  new ResponseEntity<>(HttpStatus.CONFLICT);
		}

		if (trackDTO.getMusicFile() == null || trackDTO.getMusicFile().isEmpty()) {
			logRec.setResponse("Http.Status=" + HttpStatus.BAD_REQUEST + "; File is absent");
			logService.save(logRec);
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}

		try {
			trackService.save(trackDTO.getTrack(), trackDTO.getMusicFile());
			trackService.setTrackInfo(trackDTO.getTrack().getRecid());
			logRec.setResponse("Http.Status=" + HttpStatus.CREATED);
			logService.save(logRec);
			return new ResponseEntity<>(HttpStatus.CREATED);
		} catch (Exception e) {
			logRec.setResponse("Http.Status=" + HttpStatus.INTERNAL_SERVER_ERROR + "; Error=" + e.getMessage());
			logService.save(logRec);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}

	//Метод выдачи трека, способный выдавать как весь файл сразу, так и ранжируя по байтам
	//Для получения определенный байт файла требуется задать диапазон в заголовке запроса
	//Пример: ("Range","bytes=0-49") запрашивает первые 50 байт файла
	@RequestMapping(value="/{id}/range", method = RequestMethod.GET)
	public void serveFile(@PathVariable  UUID id, HttpServletRequest request, HttpServletResponse response) {
		Track track = trackService.getById(id);
		try {
			MultipartFileSender.fromURIString(track.getPath())
					.with(request)
					.with(response)
					.serveResource();
		}catch (Exception ex){

		}
	}
}
