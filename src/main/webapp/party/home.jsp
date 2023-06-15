<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="dao.BoardDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그인 유저 조회
	String loginId = (String)session.getAttribute("loginId");
	// 파티 번호 조회
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	
	BoardDao boardDao = BoardDao.getInstance();
	
	
	// 로그인을 하지 않아도 들어가지긴 하는디...
	/* if (loginId == null) {
		response.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 접근", "UTF-8"));
	} */
	
	List<Board> boards = boardDao.getBoardsByPartyNo(partyNo);
	if (boards == null)	{
		response.sendRedirect("home.jsp");
	}
%>

<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<div class="container">
 <div>
 	
 </div>
</div>
</body>
</html>