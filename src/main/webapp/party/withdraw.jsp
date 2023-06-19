<%@page import="dao.PartyFavoritesDao"%>
<%@page import="dao.PartyDao"%>
<%@page import="vo.PartyAccess"%>
<%@page import="dao.PartyAccessDao"%>
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

// 기존 권한 조회하기
PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
PartyAccess partyAccess = partyAccessDao.getPartyAccessByPartyNoAndUserId(no, loginId);
if (partyAccess == null) {
	response.setStatus(404);
	return;
}
if (partyAccess.getAuthNo() != 6) {
	response.setStatus(403);
	return;
}

// 탈퇴하기
partyAccess.setAuthNo(8);
partyAccessDao.updatePartyAccess(partyAccess);
PartyDao.getInstance().decreaseCurCntByNo(no);
PartyFavoritesDao.getInstance().deletePartyFavorite(loginId, no);

// 응답으로 텍스트를 보내기
out.write("withdraw");
%>