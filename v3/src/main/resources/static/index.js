/**
 * Created by a.polunina on 29.08.2017.
 */
function guid() {
	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
			.toString(16)
			.substring(1);
	}
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
		s4() + '-' + s4() + s4() + s4();
}

function sendHistory(deviceid) {
	getNextTrack(deviceid, false, function(result) {
		var trackid = result;
		var api = '/v5/histories/' + deviceid + '/' + trackid;
		var xhr = new XMLHttpRequest(),
			date = new Date,
			dateFormat = date.getFullYear() + '-' + (date.getMonth() < 9 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-' + date.getDate() + "T" +
				(date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':' +
				(date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
				(date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds()),
			data = new FormData();
		data.append('recid', guid());
		data.append('islisten', '-1');
		data.append('lastlisten', dateFormat);
		xhr.open("POST", api, true, false);
		xhr.onreadystatechange = function () {
			if (xhr.readyState != 4) return;
			document.getElementById('response').innerHTML = '<div id="response"> <h3>Результат запроса к API - отправка истории</h3> response: code ' + xhr.status + ' <br/> ' + xhr.response + ' </div>';

			if (xhr.status == 201) {
				console.log('Данные о треке записаны в историю');
			} else {
				console.log('Ошибка получения данных с сервера.');
				console.log(xhr);
			}
		};
		xhr.send(data);
	});
}

function getTrackById(deviceid) {
	getNextTrack(deviceid, false, function(result){
		var trackid = result;
		var api = '/v5/tracks/' + trackid + '/' + deviceid;
		document.getElementById('response').innerHTML = '<div id="response"> <h3>Результат запроса к API - получение трека по id </h3> <audio src="' + api + '" controls autoplay> Трек успешно получен. Браузер не поддерживает аудио теги <a href="/v5/tracks/' + trackid + '/' + deviceid + '">(сохранить трек)</a>.</audio></div>';
	});
}

function getNextTrack(deviceid, isViewResponse, callback) {
	var api = '/v4/tracks/' + deviceid + '/next';
	var xhr = new XMLHttpRequest();
	var trackInfo = null;
	xhr.open('GET', api, true);
	xhr.onreadystatechange = function () {
		if(xhr.readyState != 4) return;

		if(xhr.status == 200) {
			trackInfo = JSON.parse(xhr.response);
			if(isViewResponse)
				document.getElementById('response').innerHTML = '<div id="response"> <h3>Результат запроса к API - получение следующего трека </h3> response: code ' + xhr.status + ' <br/> ' + xhr.response + ' </div>';
			callback(trackInfo.id);
		}
	};
	xhr.send();
}