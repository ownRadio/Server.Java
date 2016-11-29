package ownradio.web.rest.v3;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.History;
import ownradio.domain.Track;
import ownradio.service.DeviceService;
import ownradio.service.HistoryService;
import ownradio.service.TrackService;

import java.util.Date;
import java.util.UUID;

/**
 * Created by a.polunina on 28.11.2016.
 */
@Slf4j
@RestController
@RequestMapping("/v3/histories")
public class HistoryControllerV3 {
	private final HistoryService historyService;
	private final TrackService trackService;
	private final DeviceService deviceService;

	@Autowired
	public HistoryControllerV3(HistoryService historyService, TrackService trackService, DeviceService deviceService) {
		this.historyService = historyService;
		this.trackService = trackService;
		this.deviceService = deviceService;
	}

	@RequestMapping(value = "/{deviceId}/{trackId}", method = RequestMethod.POST)
	public ResponseEntity save(@PathVariable UUID deviceId, @PathVariable UUID trackId, @RequestBody History history) {
		try {
			log.info("{} {}",deviceId.toString(),trackId.toString());
			log.info("{} {} {}",history.getLastListen(), history.getIsListen(), history.getMethod());
			Track track = trackService.getById(trackId);
			Device device = deviceService.getById(deviceId);

			if (track == null || device == null) {
				throw new RuntimeException("Track or Device is null");
			}

			history.setTrack(track);
			history.setDevice(device);

			historyService.save(history);

			return new ResponseEntity(HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}
