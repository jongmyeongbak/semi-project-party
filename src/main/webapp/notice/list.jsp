<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="info.Pagination"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
String err = request.getParameter("err");
int pageNo = StringUtils.stringToInt(request.getParameter("page"), 1);
Integer auth = (Integer) session.getAttribute("auth");

AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
Pagination pagination;
List<Board> boardList;
// 일반이용자보다 높은 권한이 있으면 전체 조회, 아니면 삭제하지 않은 공지만 조회한다.
if (auth != null && auth < 4) {
	int totalRows = adminNoticeDao.getTotalRows();
	pagination = new Pagination(pageNo, totalRows);
	boardList = adminNoticeDao.getNotices(pagination.getFirstRow(), pagination.getLastRow());
} else {
	int totalRows = adminNoticeDao.getTotalRows("N");
	pagination = new Pagination(pageNo, totalRows);
	boardList = adminNoticeDao.getNotices("N", pagination.getFirstRow(), pagination.getLastRow());
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
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="notice"/>
</jsp:include>
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
			<h1 class="border bg-light fs-4 p-2">공지사항</h1>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<%
			if ("deleted".equals(err)) {
			%>
				<div class="alert alert-danger">
					<strong>조회 불가</strong> 선택하신 공지사항이 존재하지 않습니다.
				</div>
			<%
			}
			%>
			<p>목록을 확인하세요.</p>
			
			<table class="table table-sm">
				<colgroup>
					<col width="7%">
					<col width="13%">
					<col width="55%">
					<col width="15%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
					<%
					if (auth != null && auth < 4) {
					%>
						<th>삭제여부</th>
						<th>글쓴이</th>
					<%
					} else {
					%>
						<th colspan="2">글쓴이</th>
					<%
					}
					%>
						<th>제목</th>
						<th>등록일</th>
						<th>조회수</th>
					</tr>
				</thead>
				<tbody>
				<%
				if (auth != null && auth < 4) {
					for (Board board : boardList) {
				%>
					<tr>
						<td><%=board.getDeleted() %></td>
						<td><%=board.getUser().getNickname() %></td>
						<td><a href="detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
						<td><%=board.getCreateDate() %></td>
						<td><%=board.getReadCnt() %></td>
					</tr>
				<%
					}
				} else {
					for (Board board : boardList) {
				%>
					<tr>
						<td colspan="2"><%=board.getUser().getNickname() %></td>
						<td><a href="detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
						<td><%=board.getCreateDate() %></td>
						<td><%=board.getReadCnt() %></td>
					</tr>
				<%
					}
				}
				%>
				</tbody>
			</table>
			<nav>
				<ul class="pagination justify-content-center">
					<li class="page-item<%=pageNo <= 1 ? " disabled" : "" %>">
						<a class="page-link" href="list.jsp?page=<%=pageNo - 1 %>">이전</a>
					</li>
					<%
					int lastPageNo = pagination.getLastPageNoOnPageList();
					for (int no = pagination.getFirstPageNoOnPageList(); no <= lastPageNo; no++) {
					%>
					<li class="page-item<%=no == pageNo ? " active" : "" %>">
						<a class="page-link" href="list.jsp?page=<%=no %>"><%=no %></a>
					</li>
					<%
					}
					%>
					<li class="page-item<%=pageNo >= pagination.getTotalPages() ? " disabled" : "" %>">
						<a class="page-link" href="list.jsp?page=<%=pageNo + 1 %>">다음</a>
					</li>
				</ul>
			</nav>
			
			<%
			if (auth != null && auth < 4) {
			%>
			<div class="text-end">
				<a href="form.jsp" class="btn btn-primary btn-sm">새 공지 등록</a>
			</div>
			<%
			}
			%>
		</div>
	</div>
</div>
</body>
</html>