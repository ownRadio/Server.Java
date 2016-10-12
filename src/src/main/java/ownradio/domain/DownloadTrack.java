package ownradio.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "download_tracks")
public class DownloadTrack extends AbstractEntity {
	@ManyToOne
	@JoinColumn(name = "device_id")
	private Device device;

	@ManyToOne
	@JoinColumn(name = "track_id")
	private Track track;

}
