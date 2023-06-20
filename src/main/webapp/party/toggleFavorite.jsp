<%@page import="dao.PartyFavoritesDao"%>
<%@ page contentType="text/plain; charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
<%
String loginId = (String) session.getAttribute("loginId");
String contextPath = request.getContextPath();
if (loginId == null) {
	response.setStatus(401);
	return;
}
// 요청파라미터값 조회하기
int no = Integer.parseInt(request.getParameter("no"));
String op = request.getParameter("op");

// 즐겨찾기 추가 또는 삭제하고 응답 보내기
PartyFavoritesDao partyFavoritesDao = PartyFavoritesDao.getInstance();
if ("add".equals(op)) {
	partyFavoritesDao.insertPartyFavorite(loginId, no);
} else if ("del".equals(op)) {
	partyFavoritesDao.deletePartyFavorite(loginId, no);
}
%>