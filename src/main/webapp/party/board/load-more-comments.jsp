<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="dao.CommentDao"%>
<%@page import="vo.Comment"%>
<%@page import="java.util.List"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	int boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));
	String loginId = (String) session.getAttribute("loginId");

	// 댓글 정보 불러오기
	CommentDao commentDao = CommentDao.getInstance();
	List<Comment> comments = commentDao.getAllCommentsByBoardNo(boardNo);
	
	List<Map<String, Object>> commentsIsMine = new ArrayList<>();
   for (Comment comment : comments) {
		Map<String, Object> commentMap = new HashMap<>();
		commentMap.put("comments", comment);
		commentMap.put("isMine", comment.getUser().getId().equals(loginId));
		commentsIsMine.add(commentMap);
	}
   
    Gson gson = new GsonBuilder()
		   .setDateFormat("yyyy-MM-dd")
		   .create();
   
	String text = gson.toJson(commentsIsMine);
	
	out.write(text);
%>