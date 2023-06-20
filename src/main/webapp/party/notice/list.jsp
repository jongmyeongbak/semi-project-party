<%@page import="dao.PartyAccessDao"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.PartyNotice"%>
<%@page import="java.util.List"%>
<%@page import="info.Pagination"%>
<%@page import="dao.PartyNoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
Integer auth = (Integer) session.getAttribute("auth");  
	int pageNo = StringUtils.stringToInt(request.getParameter("page"), 1);
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	int notiNo = StringUtils.stringToInt(request.getParameter("notino"));
  	PartyNoticeDao partyNoticeDao = PartyNoticeDao.getInstance();
  	
  	Pagination pagination;
  	List<PartyNotice> partyNoticeList;

	int totalRows = partyNoticeDao.getTotalRowsByPartyNo(partyNo);
	pagination = new Pagination(pageNo, totalRows);
	partyNoticeList = partyNoticeDao.getAllPartyNoticesByPartyNo(partyNo, pagination.getFirstRow(), pagination.getLastRow());
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
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
			<h1 class="border bg-light fs-4 p-2">공지사항 목록</h1>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>목록을 확인하세요.</p>			
			<table class="table table-sm">
				<colgroup>
					<col width="10%">
					<col width="45%">
					<col width="15%">    
					<col width="15%">
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>조회수</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
<%
	if (partyNoticeList.isEmpty()) {
%>
					<tr><td colspan="5" class="text-center">작성된 글이 없습니다.</td></tr>
<%
	}
	for (PartyNotice partyNotice : partyNoticeList) {
%>
					<tr>
						<td><%=partyNotice.getNo() %></td>
						<td><a href="read.jsp?no=<%=partyNo %>&notino=<%=partyNotice.getNo()%>"><%=partyNotice.getTitle() %></a></td>
						<td><%=partyNotice.getUser().getNickname() %></td>
						<td><%=partyNotice.getReadCnt() %></td>
						<td><%=partyNotice.getCreateDate() %></td>
					</tr>
<%
	}
%>
					<tr>
				</tbody>
			</table>
			<nav>
				<ul class="pagination justify-content-center">
					<li class="page-item <%=pageNo <= 1 ? "disabled" : ""%> ">
						<a href="list.jsp?no=<%=partyNo %>&page=<%=pageNo - 1 %>" class="page-link">이전</a>
<%
	int lastPageNo = pagination.getLastPageNoOnPageList();
	for(int no = pagination.getFirstPageNoOnPageList(); no <= lastPageNo; no++){
%>					
					<li class="page-item <%=pageNo == no ? "active" : "" %>">
						<a href="list.jsp?no=<%=partyNo %>&page=<%=no %>" class="page-link"><%=no %></a>
					</li>
<%
	}
%>
					<li class="page-item <%=pageNo >= pagination.getTotalPages() ? "disabled" : ""%> ">
						<a href="list.jsp?no=<%=partyNo %>&page=<%=pageNo + 1 %>" class="page-link">다음</a>
					</li>
				</ul>
			</nav>
			
			<div class="text-end">
				<%
				String loginId = (String) session.getAttribute("loginId");
				Integer partyAuthNo = ((loginId == null) ? null : PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(partyNo, loginId));
				if (partyAuthNo != null && partyAuthNo == 6) {
				%>
				<a href="form.jsp?no=<%=partyNo %>" class="btn btn-primary btn-sm">새 공지 등록</a>
				<%
				}
				%>
			</div>
		</div>
	</div>
</div>
</body>
</html>