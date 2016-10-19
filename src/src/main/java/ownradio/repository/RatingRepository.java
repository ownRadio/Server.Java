package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.Rating;

import java.util.UUID;

/**
 * Интерфейс репозитория, для хранения рейтингов прослушанных треков
 *
 * @author Alpenov Tanat
 */
public interface RatingRepository extends JpaRepository<Rating, UUID> {
}
