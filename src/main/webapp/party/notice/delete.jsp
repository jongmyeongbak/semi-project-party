<%@page import="dao.PartyAccessDao"%>
<%@page import="vo.PartyNotice"%>
<%@page import="dao.PartyNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String loginId = (String) session.getAttribute("loginId");
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	Integer partyAuthNo = PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(partyNo, loginId);

	//로그인 상태인지 확인 후 로그인 권유
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=login" + "&redirect=/party/notice/list.jsp?no=" + partyNo);
		return;
	}
	
	int notiNo = StringUtils.stringToInt(request.getParameter("notino"));
	PartyNoticeDao partyNoticeDao = PartyNoticeDao.getInstance();
	PartyNotice partyNotice = partyNoticeDao.getPartyNoticeByNo(notiNo);
	
	// 로그인 아이디와 글작성자가 같지 않으면 삭제불가
	if (!loginId.equals(partyNotice.getUser().getId())) {
		response.sendRedirect("list.jsp?no=" + partyNo);
		return;
	} 
	// 게시글 삭제하기     
	partyNoticeDao.deletePartyNoticeByNo(notiNo);
	
	// 재요청URL - 목록으로 돌아가기
	response.sendRedirect("list.jsp?no=" + partyNo);
%>