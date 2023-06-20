<%@page import="dao.PartyAccessDao"%>
<%@page import="dao.BoardDao"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.User"%>
<%@page import="vo.Board"%>
<%@page import="vo.Comment"%>
<%@page import="dao.CommentDao"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");

	// 로그인이 되어있지 않으면 리디렉트
	if (loginId == null){
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("댓글 작성", "utf-8"));
		return;
	}
	
	int boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));
	String content = request.getParameter("content");
	
	// 파티에 가입한 적 없거나 로그인 유저의 파티접근권이 강퇴나 탈퇴인 경우 리디렉트
	// 댓글 작성 중 접근권 변경될 경우 반영
	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
	// 유저 접근권 조회
	Integer authNo = partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);
  	if (authNo == null || authNo >= 8) {
       response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("댓글 작성", "UTF-8"));
       return;
   	}
  	
    // 내용이 비어있거나 빈 문자열일 때
	if (content == null || content.isBlank()) {
		out.println("<script>alert('내용을 입력해주세요.');</script>");
		out.println("<script>history.back();</script>");
	    return;
	}
	
	// 내용의 글자수를 초과했을 경우 경고창 생성
	if (content.getBytes("UTF-8").length > 500) {
	    out.println("<script>alert('댓글의 글자수를 초과했습니다(최대500자)');</script>");
	    out.println("<script>history.back();</script>");
	    return;
	}
  	
	CommentDao commentDao = CommentDao.getInstance();
	Comment comment = new Comment();
	
	comment.setContent(content);
	comment.setBoard(new Board(boardNo));
	comment.setUser(new User(loginId));
	
	commentDao.insertComment(comment);
	
	// 게시판 댓글 수 증가
	BoardDao boardDao = BoardDao.getInstance();
	Board board = boardDao.getBoardByBoardNo(boardNo);
	board.setCommentCnt(board.getCommentCnt()+1);
	boardDao.updateBoard(board);
	
	response.sendRedirect("home.jsp?no=" + partyNo);

%>
