package ownradio.web.rest.v4;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.DownloadTrack;
import ownradio.domain.TracksHistory;
import ownradio.domain.UsersRating;
import ownradio.repository.DeviceRepository;
import ownradio.service.DeviceService;
import ownradio.service.DownloadTrackService;
import ownradio.service.UserService;

import java.util.List;
import java.util.UUID;

/**
 * Created by a.polunina on 17.03.2017.
 */
@Slf4j
//@CrossOrigin
@RestController
@RequestMapping("/v4/statistics")
public class StatisticsController {

	private final UserService userService;
	private final DeviceService deviceService;
	private final DownloadTrackService downloadTrackService;

	@Autowired
	public StatisticsController(UserService userService, DeviceService deviceService, DownloadTrackService downloadTrackService){
		this.userService = userService;
		this.deviceService = deviceService;
		this.downloadTrackService = downloadTrackService;

	}

	@RequestMapping(value = "/{userId}/getuserdevices", method = RequestMethod.GET)
	public ResponseEntity<?> getUserDevices(@PathVariable UUID userId) {
		try {
			List<Device> devices = deviceService.getByUserid(userId);

			return new ResponseEntity<>(devices, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}


	@RequestMapping(value = "/{deviceId}/{countTracks}/getlasttracks", method = RequestMethod.GET)
	public ResponseEntity<?> getLastTracksByDevice(@PathVariable UUID deviceId, @PathVariable Integer countTracks) {
		try {
			List<DownloadTrack> downloadedTracks = downloadTrackService.getLastTracksByDevice(deviceId, countTracks);
//			Device device = new Device();
//			device.setRecid(deviceId);
//			List<DownloadTrack> downloadedTracks = downloadTrackRepository.findFirst3ByDeviceOrderByReccreatedDesc(device);

			return new ResponseEntity<>(downloadedTracks, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}


	@RequestMapping(value = "/usersrating/{countRows}", method = RequestMethod.GET)
	public ResponseEntity<?> getUsersRating(@PathVariable Integer countRows) {
		try {
			List<UsersRating> usersRating = userService.getUsersRating(countRows);

			return new ResponseEntity<>(usersRating, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@RequestMapping(value = "/{deviceId}/{countTracks}/gettrackshistorybydevice", method = RequestMethod.GET)
	public ResponseEntity<?> getTracksHistoryByDevice(@PathVariable UUID deviceId, @PathVariable Integer countTracks) {
		try {
			List<TracksHistory> tracksHistories = downloadTrackService.getTracksHistoryByDevice(deviceId, countTracks);
			return new ResponseEntity<>(tracksHistories, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@RequestMapping(value = "/getlastdevices", method = RequestMethod.GET)
	public ResponseEntity<?> getLastDevices() {
		try{
			List<Device> lastActiveDevices = deviceService.getLastDevices();
			return new ResponseEntity<>(lastActiveDevices, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@RequestMapping(value = "/getlastusers/{countUsers}", method = RequestMethod.GET)
	public ResponseEntity<?> getLastUsers(@PathVariable Integer countUsers) {
		try{
			List<UsersRating> lastActiveDevices = userService.getLastUsers(countUsers);
			return new ResponseEntity<>(lastActiveDevices, HttpStatus.OK);
		}catch (Exception ex){
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}
}

