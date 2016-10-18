package ownradio.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import ownradio.domain.Device;
import ownradio.domain.History;
import ownradio.domain.Track;
import ownradio.domain.User;
import ownradio.service.DeviceService;
import ownradio.service.HistoryService;
import ownradio.service.TrackService;
import ownradio.service.UserService;

import java.beans.PropertyEditorSupport;
import java.util.UUID;

@RestController
@RequestMapping("/histories")
public class HistoryController {
	private final HistoryService historyService;
	private final UserService userService;
	private final TrackService trackService;
	private final DeviceService deviceService;

	@Autowired
	public HistoryController(HistoryService historyService, UserService userService, TrackService trackService, DeviceService deviceService) {
		this.historyService = historyService;
		this.userService = userService;
		this.trackService = trackService;
		this.deviceService = deviceService;
	}

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity save(History history) {
		try {
			historyService.save(history);

			return new ResponseEntity(HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}


	@InitBinder
	public void dataBinding(WebDataBinder binder) {
		binder.registerCustomEditor(User.class, "user", new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				User user = userService.getById(UUID.fromString(text));
				setValue(user);
			}
		});
		binder.registerCustomEditor(Track.class, "track", new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				Track track = trackService.getById(UUID.fromString(text));
				setValue(track);
			}
		});
		binder.registerCustomEditor(Device.class, "device", new PropertyEditorSupport() {
			@Override
			public void setAsText(String text) {
				Device device = deviceService.getById(UUID.fromString(text));
				setValue(device);
			}
		});
	}
}
