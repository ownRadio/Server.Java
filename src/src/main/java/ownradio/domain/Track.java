package ownradio.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tracks")
public class Track extends AbstractEntity {

	private String path;

	@ManyToOne
	@JoinColumn(name = "upload_user_id")
	private User uploadUser;

	@Column(nullable = false)
	private String localDevicePathUpload;

}
