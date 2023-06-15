<%@page import="web.PartyJoinValidator"%>
<%@page import="vo.User"%>
<%@page import="vo.PartyAccess"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="dao.PartyDao"%>
<%@page import="vo.Party"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/plain; charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
<%
// 비로그인 경우 제외
String loginId = (String) session.getAttribute("loginId");
if (loginId == null) {
	out.write("login");
	return;
}

// 파티 비활성 경우 제외
int no = StringUtils.stringToInt(request.getParameter("no"));
Party party = PartyDao.getInstance().getPartyByNo(no);
if (party == null || party.getStatus() != "활성") {
	out.write("ban");
	return;
}

PartyDao partyDao = PartyDao.getInstance();
PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
PartyAccess partyAccess = partyAccessDao.getPartyAccessByPartyNoAndUserId(no, loginId);
if (partyAccess != null) { // 가입한 적 있는 경우
	int partyAuth = partyAccess.getAuthNo();
	if (partyAuth == 9) { // 강퇴인 경우
		out.write("ban");
		return;
	} else if (partyAuth == 8) { // 비가입1. 탈퇴인 경우 권한 update
		String partyReq = PartyJoinValidator.getPartyReqWhenNotFit(no, loginId);
		if (partyReq != null) {
			out.write(partyReq);
			return;
		}
		
		partyAccess.setAuthNo(7); // 일반 파티권한 설정
		
		int quota = PartyJoinValidator.getQuotawhenExceed(no);
		if (quota > -1) {
			out.write("자리가 없습니다.\n정원: " + quota + "명");
			return;
		}
		partyDao.increaseCurCntByNo(no);
		partyAccessDao.updatePartyAccess(partyAccess);
		
		out.write("rejoin");
		return;
	} else { // 정상회원인 경우
		out.write("already");
		return;
	}
} else { // 비가입2. 미가입인 경우 권한 insert
	String partyReq = PartyJoinValidator.getPartyReqWhenNotFit(no, loginId);
	if (partyReq != null) {
		out.write(partyReq);
		return;
	}
	
	partyAccess = new PartyAccess();
	partyAccess.setParty(new Party(no));
	partyAccess.setUser(new User(loginId));

	int quota = PartyJoinValidator.getQuotawhenExceed(no);
	if (quota > -1) {
		out.write("자리가 없습니다.\n정원: " + quota + "명");
		return;
	}
	partyDao.increaseCurCntByNo(no);
	partyAccessDao.insertPartyAccess(partyAccess);
	
	out.write("join");
}
%>