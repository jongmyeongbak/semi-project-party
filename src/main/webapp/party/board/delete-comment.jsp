<%@page import="dao.BoardDao"%>
<%@page import="vo.Board"%>
<%@page import="util.StringUtils"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="vo.Comment"%>
<%@page import="dao.CommentDao"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");
	int boardNo = StringUtils.stringToInt(request.getParameter("bno")); 
	int commentNo = StringUtils.stringToInt(request.getParameter("cno")); 
	
	// 로그인이 되어있지 않으면 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("댓글 삭제", "UTF-8"));
		return;
	}
	
	// 로그인 유저와 댓글 작성자가 다르면 리디렉트
	CommentDao commentDao = CommentDao.getInstance();
 	Comment comment = commentDao.getCommentByNo(commentNo);
 	if (!loginId.equals(comment.getUser().getId())){
		response.sendRedirect("../list.jsp?err=id2&job=" + URLEncoder.encode("댓글 삭제", "UTF-8"));
		return;
 	}
 	
 	// 로그인 유저의 파티접근권이 강퇴나 탈퇴인 경우 리디렉트
 	// 댓글 삭제 중 접근권 변경될 경우 반영
 	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
 	BoardDao boardDao = BoardDao.getInstance();
 	// 게시판으로 파티 번호 조회
 	Board board = boardDao.getBoardByBoardNo(boardNo);
 	Integer partyNo = board.getParty().getNo();
 	// 유저 접근권 조회
	Integer authNo = partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);
    if (authNo >= 8) {
        response.sendRedirect("../list.jsp?err=id2&job=" + URLEncoder.encode("댓글 삭제", "UTF-8"));
        return;
    }
    
 	// 댓글 삭제
	commentDao.deleteComment(commentNo);
 	
 	// 게시판 댓글 수 감소
 	board.setCommentCnt(board.getCommentCnt()-1);
 	boardDao.updateBoard(board);
	
	response.sendRedirect("home.jsp?no=" + partyNo);
%>