package ownradio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.History;
import ownradio.repository.HistoryRepository;

@Service
public class HistoryService {

	private final HistoryRepository historyRepository;

	@Autowired
	public HistoryService(HistoryRepository historyRepository) {
		this.historyRepository = historyRepository;
	}


	public void save(History history) {
		historyRepository.saveAndFlush(history);
	}
}
