package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.History;

public interface HistoryRepository extends JpaRepository<History, String> {
}
