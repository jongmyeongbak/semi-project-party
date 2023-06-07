package util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {

	private DateUtils() {}
	
	/**
	 * yyyy-MM-dd 날짜 형식의 문자열을 받아 Date타입으로 변환합니다.
	 * dateString이 null이거나 비어있거나 공백일 경우 현재 날짜를 반환합니다.
	 * 주어진 문자열이 유효한 날짜 형식이 아닌 경우, RuntimeException을 발생시킵니다.
	 * @param dateString
	 * @return yyyy-MM-dd 날짜 형식의 문자열을 변환한 Date객체
	 * 
	 */
    public static Date stringToDate(String dateString) {
    	if (dateString == null || dateString.isBlank()) {
    		return new Date();
    	}
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return dateFormat.parse(dateString);
        } catch (ParseException ex) {
            throw new RuntimeException("날짜를 문자열을 변환하던 중 오류가 발생하였습니다." + dateString, ex);
        }
    }
}
