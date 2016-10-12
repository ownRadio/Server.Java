package ownradio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.Rating;
import ownradio.repository.RatingRepository;

@Service
public class RatingService {

	private final RatingRepository ratingRepository;

	@Autowired
	public RatingService(RatingRepository ratingRepository) {
		this.ratingRepository = ratingRepository;
	}


	public void save(Rating rating) {
		ratingRepository.saveAndFlush(rating);
	}
}
