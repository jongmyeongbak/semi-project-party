<%@page import="java.net.URLEncoder"%>
<%@page import="vo.Board"%>
<%@page import="dao.BoardDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	String loginId = (String) session.getAttribute("loginId");
	int boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));
	
	BoardDao boardDao = BoardDao.getInstance();
	Board board = boardDao.getBoardByBoardNo(boardNo);
	
	// 로그인이 되어있지 않은 경우 로그인 폼으로 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시물 삭제", "UTF-8"));
		return;
	}
	
	// 해당하는 게시물이 존재하지 않는 경우 리디렉트
	if (board == null){
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("게시물 삭제", "UTF-8"));
		return;
	}
	
	// 게시물 삭제 여부를 Y로 변경
	board.setDeleted("Y");
	boardDao.updateBoard(board);
	
	// 파티 홈으로 리디렉트
	response.sendRedirect("home.jsp?no=" + board.getParty().getNo());
	
%>