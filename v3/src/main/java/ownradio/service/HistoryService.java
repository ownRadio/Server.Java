package ownradio.service;

import ownradio.domain.History;

import java.util.UUID;

/**
 * Интерфейс сервиса, для работы с историей прослушанных треков
 *
 * @author Alpenov Tanat
 */
public interface HistoryService {
	void save(History history, Boolean isNewHistoryRec);
	History getById(UUID uuid);
}
