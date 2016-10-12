package ownradio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.Device;
import ownradio.repository.DeviceRepository;

@Service
public class DeviceService {

	private final DeviceRepository deviceRepository;

	@Autowired
	public DeviceService(DeviceRepository deviceRepository) {
		this.deviceRepository = deviceRepository;
	}


	public void save(Device device) {
		deviceRepository.saveAndFlush(device);
	}
}
