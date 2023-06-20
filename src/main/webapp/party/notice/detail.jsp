<%@page import="dao.PartyDao"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.PartyNotice"%>
<%@page import="dao.PartyNoticeDao"%>
<%@page import="vo.Board"%>
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
	if (partyAuthNo == null || partyAuthNo == 8 || partyAuthNo == 9) {
		response.sendRedirect("list.jsp?no=" + partyNo);
		return;
	}
	
	int notiNo = StringUtils.stringToInt(request.getParameter("notino"));
	PartyNoticeDao partyNoticeDao = PartyNoticeDao.getInstance();
	PartyNotice partyNotice = partyNoticeDao.getPartyNoticeByNo(notiNo);
	if (partyNotice == null || !"N".equals(partyNotice.getDeleted())) {
		response.sendRedirect("list.jsp?no=" + partyNo);
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
<style type="text/css">
	.btn.btn-xs {--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;}
</style>
</head>
<body>
<jsp:include page="../../nav.jsp">
	<jsp:param value="notice" name="pmenu"/>
</jsp:include>
<div class="container my-2">
	<div class="row mb-3">
		<div class="col-12">
			<h1 class="border bg-light fs-4 p-2">공지사항 상세 정보</h1>
	</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>상세정보를 확인하세요.</p>
			<table class="table table-bordered">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
					<tr>
						<th class="table-dark">제목</th>
						<td><%=partyNotice.getTitle() %></td>
						<th class="table-dark">작성자</th>
						<td><%=partyNotice.getUser().getNickname() %></td>
					</tr>
					<tr>
						<th class="table-dark">조회수</th>
						<td><%=partyNotice.getReadCnt()%></td>
						<th class="table-dark">등록일</th>
						<td><%=partyNotice.getCreateDate() %></td>
					</tr>
					<tr>
						<th align=center colspan='4'class="table-dark" align=center>내용</th>
					</tr>
					<tr>
						<td colspan='4'><%=partyNotice.getContent() %></td>
					</tr> 
				</tbody>
			</table>
			<div class="text-end">
<%
	if (partyAuthNo == 6) {
%>
				<a href="delete.jsp?no=<%=partyNo %>&notino=<%=notiNo %>" class="btn btn-danger btn-sm">삭제</a>
<%
	}
%>
				<a href="list.jsp?no=<%=partyNo %>" class="btn btn-primary btn-sm">목록</a>
			</div>
		</div>
	</div>
</div>
</body>
</html>