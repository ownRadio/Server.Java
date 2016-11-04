package ownradio.domain;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.util.Date;

/**
 * Сущность для хранения информации о прослушанных треках
 *
 * @author Alpenov Tanat
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "histories")
public class History extends AbstractEntity {

	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user;

	@ManyToOne
	@JoinColumn(name = "track_id")
	private Track track;

	@DateTimeFormat(pattern = "dd/MM/yyyy")
	@Column(nullable = false)
	private Date lastListen;

	@Column(nullable = false)
	private int isListen; // 1, -1

	@Column(nullable = false)
	private String method;

	@ManyToOne
	@JoinColumn(name = "device_id")
	private Device device;
}
