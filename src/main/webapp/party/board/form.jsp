<%@page import="dao.PartyAccessDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	String loginId = (String) session.getAttribute("loginId");
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	
	// 로그인 상태가 아니라면 로그인 폼으로 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시물 작성", "UTF-8"));
		return;
	}
	
	// 파티접근권한이 존재하지 않거나 회원의 상태가 강퇴나 탈퇴인 경우 파티 리스트로 리디렉트
	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
	Integer authNo = partyAccessDao.getAuthNoByIdName(loginId, partyNo);
	if (authNo == null || authNo >= 8) {
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("게시글 작성", "UTF-8"));
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

<!-- 제목, 본문, 첨부파일 -->
<div class="container">
	<div class="row mb-3">
		<div class="col">
			<h5>파티에 게시물을 작성해보세요!</h5>
		</div>
	
	</div>
</div>
</body>
</html>