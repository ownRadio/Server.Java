package ownradio.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import ownradio.domain.NextTrack;
import ownradio.domain.Track;
import ownradio.repository.TrackRepository;
import ownradio.service.TrackService;
import ownradio.util.ResourceUtil;

import java.util.List;
import java.util.UUID;

@Service
public class TrackServiceImpl implements TrackService {

	private final TrackRepository trackRepository;

	@Autowired
	public TrackServiceImpl(TrackRepository trackRepository) {
		this.trackRepository = trackRepository;
	}

	@Override
	@Transactional(readOnly = true)
	public Track getById(UUID id) {
		return trackRepository.findOne(id);
	}

	@Override
	@Transactional
	public UUID getNextTrackId(UUID deviceId) {
		return trackRepository.getNextTrackId(deviceId);
	}

	@Override
	@Transactional
	public NextTrack getNextTrackIdV2(UUID deviceId) {
		NextTrack nextTrack = new NextTrack();
		List<Object[]> objects = trackRepository.getNextTrackV2(deviceId);
		nextTrack.setTrackid(UUID.fromString((String) objects.get(0)[0]));
		nextTrack.setMethodid((Integer) objects.get(0)[1]);
		return nextTrack;
	}

	@Override
	@Transactional
	public void save(Track track, MultipartFile file) {
		boolean result = trackRepository.registerTrack(track.getRecid(), track.getLocaldevicepathupload(), track.getPath(), track.getDevice().getRecid());
		if (!result) {
			throw new RuntimeException();
		}

		Track storeTrack = trackRepository.findOne(track.getRecid());

		String dirName = storeTrack.getDevice().getUser().getRecid().toString();
		String fileName = storeTrack.getRecid() + "." + StringUtils.getFilenameExtension(file.getOriginalFilename());
		String filePath = ResourceUtil.save(dirName, fileName, file);

		storeTrack.setPath(filePath);
	}
}
