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

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class TrackServiceImpl implements TrackService {

	private final TrackRepository trackRepository;
//	private final NextTrackRepository nextTrackRepository;


	@Autowired
	public TrackServiceImpl(TrackRepository trackRepository) {
		this.trackRepository = trackRepository;
//		this.nextTrackRepository = nextTrackRepository;
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
		Object[] objects = trackRepository.getNextTrackV2(deviceId);
		List<Object> obj = (List<Object>)objects[0];
		obj.get(0);
//		for(Object tp : objects){
//			nextTrack.setTrackid(((NextTrack)tp).getTrackid());
//			nextTrack.setMethodid(((NextTrack)tp).getMethodid()) ;
//		}
////
//		objects.get(0)

			Object a = objects[0];
//		a = objects[0][1];


		for (Object o : objects) {

			if (o instanceof Integer) {
				nextTrack.setMethodid((int) o);
			} else if (o instanceof String) {
				nextTrack.setTrackid(UUID.fromString((String) o));
			}
		}
//		nextTrack.setTrackid(UUID.fromString(objects[0][0].toString()));
//		nextTrack.setMethodid((int)objects[0][1]);
		//String str = trackRepository.getNextTrackV2(deviceId);
//		nextTrack.setTrackid(UUID.fromString(str.substring(0,36)));
//		nextTrack.setMethodid(Integer.parseInt(str.substring(37,38)));
//		nextTrack =trackRepository.getNextTrackV2(deviceId);
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
