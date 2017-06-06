package ownradio.web.rest.v5;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ownradio.domain.Device;
import ownradio.domain.Log;
import ownradio.repository.DeviceRepository;
import ownradio.service.DeviceService;
import ownradio.service.LogService;

/**
 * Created by a.polunina on 06.06.2017.
 */

@Slf4j
//@CrossOrigin
@RestController("DeviceControllerV5")
@RequestMapping("/v5/devices")
public class DeviceController {
	private final DeviceRepository deviceRepository;
	private final DeviceService deviceService;
	private final LogService logService;
	@Autowired
	public DeviceController(DeviceRepository deviceRepository, DeviceService deviceService, LogService logService) {
		this.deviceRepository = deviceRepository;
		this.deviceService = deviceService;
		this.logService = logService;
	}

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity registerDevice(@RequestBody Device device){

		Log logRec = new Log();
		logRec.setDeviceid(device.getRecid());
		logRec.setRecname("RegisterDevice");
		logRec.setLogtext("POST/v5/devices recid:" + device.getRecid() + ", recname:" + device.getRecname());
		logService.save(logRec);
		if(device.getRecid() == null){
			logRec.setResponse("HttpStatus=" + HttpStatus.BAD_REQUEST);
			logService.save(logRec);
			return new ResponseEntity(HttpStatus.BAD_REQUEST);
		}
		if(deviceRepository.findOne(device.getRecid()) != null) {
			logRec.setResponse("HttpStatus=" + HttpStatus.CONFLICT);
			logService.save(logRec);
			return new ResponseEntity(HttpStatus.CONFLICT);
		}
		if(device.getRecname() == null)
			device.setRecname("New unknown device");
		deviceService.save(device);
		logRec.setResponse("HttpStatus=" + HttpStatus.CREATED + "; deviceid=" + device.getRecid());
		logService.save(logRec);
		return new ResponseEntity(HttpStatus.CREATED);
	}
}
