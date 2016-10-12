package ownradio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ownradio.domain.User;
import ownradio.repository.UserRepository;

@Service
public class UserService {
	@Autowired
	private UserRepository userRepository;

	public User getById(String id) {
		return userRepository.findOne(id);
	}

	public User save(User user) {
		return userRepository.saveAndFlush(user);
	}
}
