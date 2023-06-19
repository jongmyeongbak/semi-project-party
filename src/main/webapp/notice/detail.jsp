<%@page import="dao.AdminNoticeDao"%>
<%@page import="vo.Board"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
int no = StringUtils.stringToInt(request.getParameter("no"));
String loginId = (String) session.getAttribute("loginId");
Integer auth = (Integer) session.getAttribute("auth");

AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
Board board;
// 권한이 적으면 삭제된 것은 읽지 못하고, 삭제되지 않은 것은 읽을 수 있기 때문에 조회수를 증가시킴
if (auth == null || auth > 3) { // 권한이 적은 경우
	board = adminNoticeDao.getNoticeByNo(no, "N"); // 발행되었으며 삭제되지 않은 것만 읽음
	if (board == null) { // 글이 없으면 리다이렉트
		response.sendRedirect("list.jsp?err=deleted");
		return;
	} else { // 글이 있으면 조회수 증가
		board.setReadCnt(board.getReadCnt() + 1);
		adminNoticeDao.increaseReadCnt(no);
	}
} else { // 권한이 많은 경우
	board = adminNoticeDao.getNoticeByNo(no); // 모두 읽음
	if (board == null) { // 글이 없으면 리다이렉트
		response.sendRedirect("list.jsp?err=deleted");
		return;
	}
}
String err = request.getParameter("err");
String job = request.getParameter("job");
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
			<p>상세 내용을 확인하세요.</p>
			<table class="table table-bordered">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>
				<tbody>
					<tr>
						<%
						if (auth != null && auth < 4) {
						%>
						<th class="table-dark">제목</th>
						<td style='white-space: break-spaces;'><%=board.getTitle() %></td>
						<th class="table-dark">삭제여부</th>
						<td><%=board.getDeleted() %></td>
						<%
						} else {
						%>
						<th class="table-dark">제목</th>
						<td colspan="3" style='font-weight: bolder; white-space: break-spaces;'><%=board.getTitle() %></td>
						<%
						}
						%>
					</tr>
					<tr>
						<th class="table-dark">글쓴이</th>
						<td><%=board.getUser().getNickname() %></td>
						<th class="table-dark">조회수</th>
						<td><%=board.getReadCnt() %></td>
					</tr>
					<tr>
						<th class="table-dark">등록일</th>
						<td><%=board.getCreateDate() %></td>
						<th class="table-dark">최종수정일</th>
						<td><%=board.getUpdateDate() %></td>
					</tr>
					<tr>
						<td style='white-space: break-spaces;' colspan="4"><%=board.getContent() %></td>
					</tr>
				</tbody>
			</table>
			<div class="text-end">
				<%
				if (loginId != null && loginId.equals(board.getUser().getId())) {
				%>
				<a href="delete.jsp?no=<%=no %>" class="btn btn-danger btn-sm">삭제</a>
				<a href="modify-form.jsp?no=<%=no %>" class="btn btn-warning btn-sm">수정</a>
				<%
				}
				%>
				<a href="list.jsp" class="btn btn-primary btn-sm">목록</a>
			</div>
		</div>
	</div>
	<%
	if ("id".equals(err)) {
	%>
		<div class="col-7">
			<div class="alert alert-danger">
				<strong>회원 불일치</strong> [<%=job %>]은(는) 본인만 가능합니다.
			</div>
		</div>
	<%
	} else if ("del".equals(err)) {
	%>
		<div class="col-7">
			<div class="alert alert-danger">
				<strong>삭제된 글</strong> [<%=job %>]은(는) 삭제되어 불가능합니다.
			</div>
		</div>
	<%
	}
	%>
</div>
</body>
</html>