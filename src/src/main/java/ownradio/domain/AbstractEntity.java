package ownradio.domain;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;
import ownradio.annotation.DisplayName;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

/**
 * Базовый класс для всех сущностей
 * Created by Tanat on 29.09.2016.
 */
@Getter
@Setter
@MappedSuperclass
public abstract class AbstractEntity implements Serializable {

	@DisplayName(key = "id")
	@Id
	@GeneratedValue(generator = "uuid")
	@GenericGenerator(name = "uuid", strategy = "uuid2")
	@Column(unique = true)
	private UUID id;

	@DisplayName(key = "version")
	@Version
	private Integer version;

	private Date createdAt;
	private Date updatedAt;

	@PrePersist
	public void beforePersist() {
		setCreatedAt(new Date());
	}

	@PreUpdate
	public void beforeUpdate() {
		setUpdatedAt(new Date());
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		AbstractEntity that = (AbstractEntity) o;

		return id != null ? id.equals(that.id) : that.id == null;

	}

	@Override
	public int hashCode() {
		return id != null ? id.hashCode() : 0;
	}
}
