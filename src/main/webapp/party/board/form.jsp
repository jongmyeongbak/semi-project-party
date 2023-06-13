<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	String loginId = (String) session.getAttribute("loginId");
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	
	// 로그인 상태가 아니라면 로그인 폼으로 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?req&job=" + URLEncoder.encode("게시글 작성", "UTF-8"));
		return;
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
<jsp:include page="../../nav.jsp">
	<jsp:param value="home" name="pmenu"/>
</jsp:include>
<div class="container">
	<div class="row mb-3">
		<div class="col">
			<h5>파티에 게시물을 작성해보세요.</h5>
			<form class="border bg-light p-3"action="insert" method="post" enctype="multipart/form-data">
			</form>
		</div>
	
	</div>
</div>
</body>
</html>