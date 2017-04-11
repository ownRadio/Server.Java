package ownradio.web.rest.v4;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.User;
import ownradio.repository.DeviceRepository;
import ownradio.service.DeviceService;
import ownradio.service.UserService;

import java.util.UUID;

/**
 * Created by a.polunina on 03.04.2017.
 */
@Slf4j
//@CrossOrigin
@RestController
@RequestMapping("/v4/devices")
public class DeviceController {
	private final DeviceRepository deviceRepository;

	@Autowired
	public DeviceController(DeviceRepository deviceRepository) {
		this.deviceRepository = deviceRepository;
	}

	@RequestMapping(value = "/{deviceId}/registerdevice", method = RequestMethod.GET)
		public ResponseEntity<?> registerDevice(@PathVariable UUID deviceId){
		return getResponseEntityRegisterDevice(deviceId, null);
	}

	@RequestMapping(value = "/{deviceId}/{deviceName}/registerdevice", method = RequestMethod.GET)
	public ResponseEntity<?> registerDevice(@PathVariable UUID deviceId, @PathVariable String deviceName){
		return getResponseEntityRegisterDevice(deviceId, deviceName);
	}

	private ResponseEntity<?> getResponseEntityRegisterDevice(UUID deviceId, String deviceName) {
		if(deviceName == null)
			deviceName = "New unknown device";
		deviceRepository.registerdevice(deviceId, deviceName);
		return new ResponseEntity(HttpStatus.OK);
	}
}
