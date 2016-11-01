# Java сервер для OwnRadio 

Этот проект разрабатывается с целью тестирования и обкатки Java технологий  

Run
---
##### Запускаем с помощью maven
* $ mvn -Dupload.dir=c:\ -Dspring.profiles.active=dev spring-boot:run
* $ mvn -Dupload.dir=c:\ -Dspring.profiles.active=prod spring-boot:run

##### Запускаем упакованный jar 
* $ java -Dupload.dir=c:\ -jar ownradio.jar --spring.profiles.active=dev
* $ java -Dupload.dir=c:\ -jar ownradio.jar --spring.profiles.active=prod


Web API
---

### Загрузка трека на сервер

##### POST /api/v2/tracks
* `file` – загружаемый файл
* `uploadUser` – UUID пользователя который производит загрузку
* `localDevicePathUpload` - Полный путь трека с которого происходил Upload трека

##### HttpStatus
* `400, "Bad Request"` - Если пользователь ввел некорректные данные
* `201, "Created"` – если все ок
* `500, "Internal Server Error"` – если произошел сбой на сервере

### Получение трека с сервера
##### GET /api/v2/tracks/id
* `id` – UUID трека 
##### HttpStatus
* `200, "OK"` – в теле ответа будет лежать трек
* `404, "Not Found"` – если трек с таким id не найден

### Получение следующего трека с сервера
##### GET /api/v2/tracks/{deviceId}/next
* `deviceId` – UUID девайса
##### HttpStatus
* `200, "OK"` – в теле ответа будет лежать UUID трека
* `404, "Not Found"` – если трек с таким id не найден

### Сохранение истории треков
##### POST /api/v2/histories
* `user` – UUID пользователя прослушавшего трек
* `track` – UUID прослушанного трека
* `lastListen` - Время последнего прослушивания или пропуска трека для данного пользователя
* `listen` - Признак прослушан ли трек до конца:  1 - прослушан, 0 – нет
* `method` - Метод выбора трека 
* `device` – UUID устройства где был прослушан трек
##### HttpStatus
* `200, "OK"` – если все ок
* `500, "Internal Server Error"` – если произошел сбой на сервере
