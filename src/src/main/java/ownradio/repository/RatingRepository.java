package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.Rating;

public interface RatingRepository extends JpaRepository<Rating, String> {
}
