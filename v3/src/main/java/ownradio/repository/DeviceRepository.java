package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ownradio.domain.Device;

import java.util.List;
import java.util.UUID;

/**
 * Интерфейс репозитория, для хранения девайсов
 *
 * @author Alpenov Tanat
 */
public interface DeviceRepository extends JpaRepository<Device, UUID> {
	@Query(value = "select * from devices where userid = ?1", nativeQuery = true)
	List<Device> getUserDevices(UUID userid);

	@Query(value = "select * from registerdevice(?1, ?2)", nativeQuery = true)
	boolean registerdevice(UUID deviceId, String deviceName);

	@Query(value = "select * from getlastdevices()", nativeQuery = true)
	List<String> getLastDevices();
}
