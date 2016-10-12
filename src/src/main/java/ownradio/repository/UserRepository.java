package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.User;

public interface UserRepository extends JpaRepository<User, String> {
}
