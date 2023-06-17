<%@page import="dao.PartyAccessDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	String loginId = (String) session.getAttribute("loginId");
	int boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));
	
	BoardDao boardDao = BoardDao.getInstance();
	Board board = boardDao.getBoardByBoardNo(boardNo);
	
	// 로그인이 되어있지 않은 경우 로그인 폼으로 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시물 삭제", "UTF-8"));
		return;
	}
	
	// 삭제할 게시물이 존재하지않거나 로그인된 아이디와 게시물 작성자의 아이디가 일치하지 않으면 리디렉트
	if (board == null || !loginId.equals(board.getUser().getId())) {
		response.sendRedirect("../list.jsp?err=id&job=" + URLEncoder.encode("게시물 삭제", "UTF-8"));
		return;
	}
	
	// 파티접근권 자체가 존재하지 않거나(파티에 가입한 적 없음) 유저 접근권의 상태가 강퇴나 탈퇴인 경우 파티 리스트로 리디렉트
	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
	Integer authNo = partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);	
	if (authNo == null || authNo >= 8) {
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("게시글 삭제", "UTF-8"));
		return;
	}
	
	// 게시물 삭제 여부를 Y로 변경
	board.setDeleted("Y");
	boardDao.updateBoard(board);
	
	// 파티 홈으로 리디렉트
	response.sendRedirect("home.jsp?no=" + board.getParty().getNo());
	
%>