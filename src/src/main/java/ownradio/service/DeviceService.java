package ownradio.service;

import ownradio.domain.Device;

import java.util.UUID;

/**
 * Created by Tanat on 17.10.2016.
 */
public interface DeviceService {
	void save(Device device);

	Device getById(UUID uuid);
}
