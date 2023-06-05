package util;

public class StringUtils {

	private StringUtils() {
	}
	
	/**
	 * 문자열을 전달받아 정수로 변환하여 반환한다.
	 * @param text 숫자로 구성된 문자열
	 * @return 정수값. text가 null, 빈 문자열, 또는 숫자가 아닌 것을 포함한 문자열이면 0이 반환된다.
	 */
	public static int stringToInt(String text) {
		return stringToInt(text, 0);
	}
	
	/**
	 * 문자열을 전달받아 정수로 변환하여 반환한다.
	 * @param text 숫자로 구성된 문자열
	 * @param defaultValue 기본값
	 * @return 정수값. text가 null, 빈 문자열, 또는 숫자가 아닌 것을 포함한 문자열이면 defaultValue가 반환된다.
	 */
	public static int stringToInt(String text, int defaultValue) {
		if (text == null || text.isBlank()) {
			return defaultValue;
		}
		try {
			return Integer.parseInt(text);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}
}
