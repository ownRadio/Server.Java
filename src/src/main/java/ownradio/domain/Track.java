package ownradio.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

/**
 * Сущность для хранения информации о треке
 *
 * @author Alpenov Tanat
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tracks")
public class Track extends AbstractEntity {

	private String path;

	@ManyToOne
	@JoinColumn(name = "device_id")
	private Device device;

	@Column(nullable = false)
	private String localDevicePathUpload;

}
