<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
int pageNo = StringUtils.stringToInt(request.getParameter("page"), 1);
int rows = 3;
int pages = 1;
int first = (pageNo -1) * rows+1;
int last = pageNo * rows;
AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
List<Board> adminNoticeList = adminNoticeDao.getNotices(first, last);

%>
<!doctype html>
<html lang="ko">
<head>
<title>밴드홈입니다.</title>
<style >
	div.smallnotice {
  	position: relative;
  	top: 50px;
 	left: 100px;
  	padding: 10px; 
  	
}
	div.directNotice {
  		position: relative;
  		top: 70px;
  		left: 730px;
  		margin-bottom: 30px;
  		font-size: 20px;
		}
	thead {
		font-size : 20px;
		text-align: center;
	}
	tbody {
		font-size : 20px;
		text-align: center;
	}
</style>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<jsp:include page="nav.jsp">
	<jsp:param name="menu" value="home"/>
</jsp:include>
<div class="smallnotice">
<h1>공지사항</h1>
</div>
<div class ="directNotice"> 	
	<a href="notice/list.jsp">더보기</a>
</div>

<div class="smallnotice my-3">
	<div class="row mb-3">
		<div class="col-5">
			<h1 class="border bg-light fs-4 p-2">공지사항</h1>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-5">
			<table class="table table-sm">
				<colgroup>
					<col width="10%">
					<col width="60%">
					<col width="20%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>글쓴이</th>
						<th>제목</th>
						<th>등록일</th>
						<th>조회수</th>
					</tr>
				</thead>
				<tbody>
<%
	for(Board board: adminNoticeList){
%>
		<td><%=board.getUser().getNickname() %></td>
		<td><a href="detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
		<td><%=board.getCreateDate() %></td>
		<td><%=board.getReadCnt() %></td>
<% 
	}
%>		
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>