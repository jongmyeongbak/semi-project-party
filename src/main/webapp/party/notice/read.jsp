<%@page import="vo.PartyNotice"%>
<%@page import="dao.PartyNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%	// 요청한 값 조회하기
	int notiNo = StringUtils.stringToInt(request.getParameter("notino"));
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));

	// 게시글 번호에 해당하는 게시글 상세 정보 조회하기
	PartyNoticeDao partyNoticeDao = PartyNoticeDao.getInstance();
	PartyNotice partyNotice = partyNoticeDao.getPartyNoticeByNo(notiNo);
	// 조회된 게시글 정보에서 조회수를 1 증가
	partyNotice.setReadCnt(partyNotice.getReadCnt() + 1);
	partyNoticeDao.increasePartyNoticeReadCnt(notiNo);
	
	// 조회수가 변경된 게시글을 DB에 저장
	partyNoticeDao.updatePartyNotice(partyNotice);
	
	// 재요청 URL 전달
	response.sendRedirect("detail.jsp?no=" + partyNo + "&notino=" + notiNo);	
%>