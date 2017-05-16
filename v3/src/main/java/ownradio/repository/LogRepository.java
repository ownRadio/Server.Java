package ownradio.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ownradio.domain.Log;

import java.util.UUID;

/**
 *  Интерфейс репозитория, для хранения логов
 *
 * Created by a.polunina on 16.05.2017.
 */
public interface LogRepository extends JpaRepository<Log, UUID> {
}
