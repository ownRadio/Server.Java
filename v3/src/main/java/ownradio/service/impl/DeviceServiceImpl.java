package ownradio.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.Device;
import ownradio.domain.UsersRating;
import ownradio.repository.DeviceRepository;
import ownradio.service.DeviceService;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class DeviceServiceImpl implements DeviceService {

	private final DeviceRepository deviceRepository;

	@Autowired
	public DeviceServiceImpl(DeviceRepository deviceRepository) {
		this.deviceRepository = deviceRepository;
	}


	@Override
	public void save(Device device) {
		deviceRepository.saveAndFlush(device);
	}

	@Override
	public Device getById(UUID uuid) {
		return deviceRepository.findOne(uuid);
	}

	@Override
	public List<Device> getByUserid(UUID uuid) {
		return deviceRepository.getUserDevices(uuid);
	}

	@Override
	public List<Device> getLastDevices(){
		List<Device> lastDevices = new ArrayList<Device>();
		List<String> objects = deviceRepository.getLastDevices();
		if (objects != null) {
			for (int i = 0; i < objects.size(); i++) {
				lastDevices.add(getById(UUID.fromString((String) objects.get(i))));
			}
		}
		return lastDevices;
	}
}
