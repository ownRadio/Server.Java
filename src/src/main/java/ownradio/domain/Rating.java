package ownradio.domain;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ratings")
public class Rating extends AbstractEntity {
	@ManyToOne
	@JoinColumn(name = "user_id")
	private User user;

	@ManyToOne
	@JoinColumn(name = "track_id")
	private Track trackId;

	@DateTimeFormat(pattern = "dd/MM/yyyy")
	@Column(nullable = false)
	private Date lastListen;

	@Column(nullable = false)
	private Integer ratingSum;
}
