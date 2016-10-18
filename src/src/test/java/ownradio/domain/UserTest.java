package ownradio.domain;

import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import static org.hamcrest.Matchers.equalTo;
import static org.junit.Assert.assertThat;
import static ownradio.util.ReflectUtil.getDisplayNameFields;

public class UserTest {

	private Map<String, String> expected;

	@Before
	public void setUp() throws Exception {
		expected = new HashMap<>();
	}

	@Test
	public void showDisplayNameRu() throws Exception {
		Locale.setDefault(new Locale("ru"));

		expected.put("id", "Название идентификатора на ru");
		expected.put("version", "Version ru");
		expected.put("user.name", "Имя пользователя");

		Map<String, String> actual = getDisplayNameFields(new User());

		assertThat(actual, equalTo(expected));
	}

	@Test
	public void showDisplayNameEn() throws Exception {
		Locale.setDefault(new Locale("en"));

		expected.put("id", "Название идентификатора на en");
		expected.put("version", "Version en");
		expected.put("user.name", "User name");

		Map<String, String> actual = getDisplayNameFields(new User());

		assertThat(actual, equalTo(expected));
	}
}