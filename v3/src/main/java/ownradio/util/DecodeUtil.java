package ownradio.util;

import com.mpatric.mp3agic.ID3v2;

/**
 * Created by a.polunina on 11.01.2017.
 * Класс утилита для декодирования строк
 */
public class DecodeUtil {

	//Функция декодирует "Cp1251" в "UTF16"
	public static String Decode(String str) {
		try {

			char[] charArray = str.toCharArray();
			for (char characher : charArray) {
				if (characher >= 'А' - 848 && characher <= 'ё' - 848) {
					return new String(str.getBytes("UTF16"), "Cp1251").replaceAll("\u0000", "").substring(2);
				}
			}
			return null;
		} catch (Exception ex) {
			return null;
		}
	}
}
