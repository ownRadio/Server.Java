package ownradio.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.History;
import ownradio.repository.HistoryRepository;
import ownradio.service.HistoryService;

@Service
public class HistoryServiceImpl implements HistoryService {

	private final HistoryRepository historyRepository;

	@Autowired
	public HistoryServiceImpl(HistoryRepository historyRepository) {
		this.historyRepository = historyRepository;
	}


	@Override
	public void save(History history) {
		historyRepository.saveAndFlush(history);
	}
}
