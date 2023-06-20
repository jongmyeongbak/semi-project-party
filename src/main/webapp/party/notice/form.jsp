<%@page import="dao.PartyAccessDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");
	Integer auth = (Integer) session.getAttribute("auth");
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	
	//로그인 상태인지 확인 후 로그인 권유
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=login" + "&redirect=/party/notice/list.jsp?no=" + partyNo);
		return;
	}
	
	Integer partyAuthNo = PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(partyNo, loginId);
	if (!(partyAuthNo != null && partyAuthNo == 6)) {
		response.sendRedirect("../board/home.jsp?no=" + partyNo);
		return;
	}
	
	String err = request.getParameter("err");

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
	<jsp:param value="notice" name="pmenu"/>
</jsp:include>
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
         	<h1 class="border bg-light fs-4 p-2">공지사항 등록하기</h1>
<%
	if ("blank".equals(err)) {
%>
		<div class="alert alert-danger">
			<strong>작성 실패</strong> 제목 또는 본문이 비어있습니다.
		</div>
<% 
	}
%>
      	</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>제목과 내용을 입력하세요.</p>		
			<form class="border bg-light p-3" method="post" action="insert.jsp" >
			<input type="hidden" name="partyNo" value="<%= partyNo %>"/>
				<div class="form-group mb-2">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" required/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">내용</label>
					<textarea rows="5" class="form-control" name="content" required></textarea>
				</div>
				<div class="text-end mb-2">
					<button type="button" class="btn btn-secondary btn-sm" onclick="confirm('작성 중인 내용이 저장되지 않고 사라집니다.') && history.back()">취소</button>
					<button type="submit" class="btn btn-primary btn-sm" onclick="return confirm('등록하시겠습니까?')">등록</button>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>