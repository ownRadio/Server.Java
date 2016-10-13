package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.History;

import java.util.UUID;

public interface HistoryRepository extends JpaRepository<History, UUID> {
}
