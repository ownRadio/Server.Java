package ownradio.service;

import ownradio.domain.User;

import java.util.UUID;

/**
 * Created by Tanat on 17.10.2016.
 */
public interface UserService {
	User getById(UUID id);

	User save(User user);
}
