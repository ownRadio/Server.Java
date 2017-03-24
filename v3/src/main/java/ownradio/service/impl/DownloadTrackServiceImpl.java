package ownradio.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ownradio.domain.DownloadTrack;
import ownradio.repository.DownloadTrackRepository;
import ownradio.service.DownloadTrackService;

import java.util.List;
import java.util.UUID;

@Service
public class DownloadTrackServiceImpl implements DownloadTrackService {

	private final DownloadTrackRepository downloadTrackRepository;

	@Autowired
	public DownloadTrackServiceImpl(DownloadTrackRepository downloadTrackRepository) {
		this.downloadTrackRepository = downloadTrackRepository;
	}

	@Override
	public void save(DownloadTrack downloadTrack) {
		downloadTrackRepository.saveAndFlush(downloadTrack);
	}

	@Override
	@Transactional
	public List<DownloadTrack> getLastTracksByDevice(UUID deviceId, Integer countTracks) {
		return downloadTrackRepository.getLastTracksByDevice(deviceId, countTracks);
	}
}
