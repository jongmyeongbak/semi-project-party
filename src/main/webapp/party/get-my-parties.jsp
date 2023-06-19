<%@page import="com.google.gson.Gson"%>
<%@page import="dto.UserPartyDto"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserPartyDtoDao"%>
<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
<%
String loginId = (String) session.getAttribute("loginId");
String contextPath = request.getContextPath();
if (loginId == null) {
	response.setStatus(401);
	return;
}
// 요청파라미터값 조회하기
String tab = request.getParameter("tab");

// 기존 권한 조회하기
UserPartyDtoDao userPartyDtoDao = UserPartyDtoDao.getInstance();
List<UserPartyDto> partyList = null;
if ("favorite".equals(tab)) {
	partyList = userPartyDtoDao.getAllMyFavoriteParties(loginId);
} else if ("managed".equals(tab)) {
	partyList = userPartyDtoDao.getAllMyManagedParties(loginId);
} else {
	partyList = userPartyDtoDao.getAllMyParties(loginId);
}

//json을 응답으로 보내기
out.write(new Gson().toJson(partyList));
%>