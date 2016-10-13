package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.User;

import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
}
