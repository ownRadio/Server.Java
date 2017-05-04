package ownradio.web.rest.v4;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.History;
import ownradio.domain.Track;
import ownradio.service.DeviceService;
import ownradio.service.HistoryService;
import ownradio.service.TrackService;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

/**
 * Created by a.polunina on 14.03.2017.
 */
@Slf4j
//@CrossOrigin
@RestController("HistoryControllerV4")
@RequestMapping("/v4/histories")
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
				return new ResponseEntity(HttpStatus.NOT_FOUND);

			log.info("deviceId:{} trackId: {}",deviceId.toString(),trackId.toString());
			log.info("{} {} {} {}",history.getRecid(), history.getLastListen(), history.getIsListen(), history.getMethodid());
			Track track = trackService.getById(trackId);
			Device device = deviceService.getById(deviceId);

			if (track == null || device == null) {
				throw new RuntimeException("Track or Device is null");
			}

//			if(historyService.getById(history.getRecid()) == null) {
//				History newHistory = history;
//				newHistory.setRecid(newHistory.getRecid());
			if(history.getRecid() != null){
				History historyTemp = historyService.getById(history.getRecid());
				if(historyTemp != null){
					historyTemp.setCountsend(((historyTemp.getCountsend()==null?0:historyTemp.getCountsend())) + 1);
//					historyTemp.setComment(historyTemp.getComment() + (new Date()).toString() + "; ");
					historyService.save(historyTemp, false);
					return new ResponseEntity(HttpStatus.ALREADY_REPORTED);
				} else {
					historyTemp = new History();
					historyTemp.setRecid(history.getRecid());
					historyTemp.setTrack(track);
					historyTemp.setDevice(device);
					historyTemp.setCountsend(1);
					historyTemp.setIsListen(history.getIsListen());
					historyTemp.setLastListen(history.getLastListen());
					historyService.save(historyTemp, true);
				}
			} else {
				history.setTrack(track);
				history.setDevice(device);
				history.setCountsend(1);
				historyService.save(history, true);
			}
				log.info("Save history, rating and update ratios");
			//}
			return new ResponseEntity(HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}