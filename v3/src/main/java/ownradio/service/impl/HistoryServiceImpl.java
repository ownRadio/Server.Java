package ownradio.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ownradio.domain.History;
import ownradio.domain.Rating;
import ownradio.repository.DownloadTrackRepository;
import ownradio.repository.HistoryRepository;
import ownradio.repository.RatingRepository;
import ownradio.repository.RatioRepository;
import ownradio.service.HistoryService;

@Service
public class HistoryServiceImpl implements HistoryService {

	private final HistoryRepository historyRepository;
	private final RatingRepository ratingRepository;
	private final RatioRepository ratioRepository;
	private final DownloadTrackRepository downloadTrackRepository;

	@Autowired
	public HistoryServiceImpl(HistoryRepository historyRepository, RatingRepository ratingRepository, RatioRepository ratioRepository, DownloadTrackRepository downloadTrackRepository) {
		this.historyRepository = historyRepository;
		this.ratingRepository = ratingRepository;
		this.ratioRepository = ratioRepository;
		this.downloadTrackRepository = downloadTrackRepository;
	}

	@Transactional
	@Override
	public void save(History history) {
		historyRepository.saveAndFlush(history);

		Rating rating = ratingRepository.findByUserAndTrack(history.getDevice().getUser(), history.getTrack());
		if(rating != null) {
			int ratingsum = rating.getRatingsum() + history.getIsListen();
			rating.setLastlisten(history.getLastListen());
			rating.setRatingsum(ratingsum);
			ratingRepository.saveAndFlush(rating);
		}
		else {
			rating = new Rating();
			rating.setUser(history.getDevice().getUser());
			rating.setTrack(history.getTrack());
			rating.setLastlisten(history.getLastListen());
			rating.setRatingsum(history.getIsListen());
			ratingRepository.saveAndFlush(rating);
		}

		try {
			ratioRepository.updateRatios(history.getDevice().getRecid());
		}catch (Exception ex){
			ex.printStackTrace();
		}
	}
}
