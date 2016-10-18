package ownradio.command;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import ownradio.domain.User;
import ownradio.service.UserService;

@Component
public class InitDb implements CommandLineRunner {
	@Autowired
	private UserService userService;

	@Override
	public void run(String... strings) throws Exception {
		User user = new User();
		userService.save(user);
		System.out.println(user.getId());
	}
}
