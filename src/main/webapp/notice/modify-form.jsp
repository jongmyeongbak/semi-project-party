<%@page import="vo.Board"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
// 유저권한이 없으면 list로 리다이렉트
Integer auth = (Integer) session.getAttribute("auth");
if (auth == null || auth > 3) {
	response.sendRedirect("list.jsp");
	return;
}

String loginId = (String) session.getAttribute("loginId");
int no = StringUtils.stringToInt(request.getParameter("no"));

AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
Board board = adminNoticeDao.getNoticeByNo(no);

//해당 글이 없다면 list로 리다이렉트
if (board == null) {
	response.sendRedirect("list.jsp");
	return;
}
//이미 삭제되었다면 detail로 리다이렉트
if ("Y".equals(board.getDeleted())){
	response.sendRedirect("detail.jsp?no="+ no +"&err=del&job=" + URLEncoder.encode("공지수정", "utf-8"));
	return;
}
//다른 사람의 글이라면 detail로 리다이렉트
if (!board.getUser().getId().equals(loginId)){
	response.sendRedirect("detail.jsp?no="+ no +"&err=id&job=" + URLEncoder.encode("공지수정", "utf-8"));
	return;
}

String err = request.getParameter("err");
String job = request.getParameter("job");
%>
<!doctype html>
<html lang="ko">
<head>
	<title></title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="게시판"/>
</jsp:include>
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
         	<h1 class="border bg-light fs-4 p-2">공지사항 수정폼</h1>
      	</div>
	</div>
	<div class="col-6">
		<%
		if ("empty".equals(err)) {
		%>
		<div class="alert alert-danger">
			<strong>작성 실패</strong> 제목 또는 본문이 비어있습니다.
		</div>
		<%
		}
		%>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>제목과 본문을 변경할 수 있습니다.</p>		
			<form class="border bg-light p-3" method="post" action="modify.jsp">
				<input type="hidden" name="no" value="<%=no %>"/>
				<div class="form-group mb-2">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" value="<%=board.getTitle() %>" required>
				</div>
				<div class="form-group mb-3">
					<label class="form-label">내용</label>
					<textarea rows="5" class="form-control" name="content" required><%=board.getContent() %></textarea>
				</div>
				<div class="text-end mb-2">
					<button type="button" class="btn btn-secondary btn-lg me-1" onclick="history.back()">취소</button>
					<button type="submit" class="btn btn-primary btn-lg">수정</button>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>