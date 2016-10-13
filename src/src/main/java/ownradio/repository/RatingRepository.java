package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.Rating;

import java.util.UUID;

public interface RatingRepository extends JpaRepository<Rating, UUID> {
}
