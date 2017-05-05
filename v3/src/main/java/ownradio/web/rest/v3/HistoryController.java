package ownradio.web.rest.v3;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.History;
import ownradio.domain.Track;
import ownradio.repository.DeviceRepository;
import ownradio.repository.TrackRepository;
import ownradio.service.DeviceService;
import ownradio.service.HistoryService;
import ownradio.service.TrackService;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.UUID;

/**
 * Created by a.polunina on 28.11.2016.
 */
@Slf4j
@RestController("HistoryControllerV3")
@RequestMapping("/v3/histories")
public class HistoryController {
	private final HistoryService historyService;
	private final TrackService trackService;
	private final DeviceService deviceService;

	@Autowired
	public HistoryController(HistoryService historyService, TrackService trackService, DeviceService deviceService) {
		this.historyService = historyService;
		this.trackService = trackService;
		this.deviceService = deviceService;
	}

	@Data
	private static class HistoryDTO {
		private UUID deviceId;
		private UUID trackId;
		private String lastListen;
		private int isListen; // 1, -1
		private Integer methodid;

		public History getHistory() {
			Calendar calendar;
			try {
				calendar = Calendar.getInstance();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'H:m:s");
				calendar.setTime( sdf.parse(lastListen));
			}catch (Exception ex){
				calendar = null;
			}

			History history = new History();
			history.setLastListen(calendar);
			history.setIsListen(isListen);
			history.setMethodid(methodid);

			return history;
		}
	}

	//form-data
	@RequestMapping(value = "/{deviceId}/{trackId}", method = RequestMethod.POST)
	public ResponseEntity save(@PathVariable UUID deviceId, @PathVariable UUID trackId, HistoryDTO historyDTO) {
		return getResponseEntity(deviceId, trackId, historyDTO.getHistory());
	}

	//json
	@RequestMapping(value = "/{deviceId}/{trackId}", method = RequestMethod.POST, headers = "Content-Type=application/json")
	public ResponseEntity save2(@PathVariable UUID deviceId, @PathVariable UUID trackId, @RequestBody History history) {
		return getResponseEntity(deviceId, trackId, history);
	}

	private ResponseEntity getResponseEntity(@PathVariable UUID deviceId, @PathVariable UUID trackId, @RequestBody History history) {
		try {
			if(deviceService.getById(deviceId) == null || trackService.getById(trackId) == null)
				return new ResponseEntity(HttpStatus.OK);

			log.info("deviceId:{} trackId: {}",deviceId.toString(),trackId.toString());
			log.info("{} {} {}",history.getLastListen(), history.getIsListen(), history.getMethodid());
			Track track = trackService.getById(trackId);
			Device device = deviceService.getById(deviceId);

			if (track == null || device == null) {
				throw new RuntimeException("Track or Device is null");
			}

			history.setTrack(track);
			history.setDevice(device);

			historyService.save(history, true);
			log.info("Save history, rating and update ratios");
			return new ResponseEntity(HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}
