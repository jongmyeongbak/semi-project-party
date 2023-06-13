<%@page import="dao.UserPartyAccessDao"%>
<%@page import="vo.PartyAccess"%>
<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="dao.BoardDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회 (로그인유저, 파티번호)
	
	// 로그인 유저 조회
	String loginId = (String)session.getAttribute("loginId");
	// 파티 번호 조회
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	// 에러 코드 조회
	String err = request.getParameter("err");
	String job = request.getParameter("job");
	
	UserPartyAccessDao userPartyAccessDao = UserPartyAccessDao.getInstance();	
	BoardDao boardDao = BoardDao.getInstance();
	
	// 글쓰기 버튼 노출을 위해 해당 파티에 가입된 사용자인지 확인
	PartyAccess partyAccess = null;
	if (loginId != null) {
		partyAccess = userPartyAccessDao.getUserPartyAccessByPartyNoUserId(partyNo, loginId);
	}
	
	List<Board> boards = boardDao.getBoardsByPartyNo(partyNo);
%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">

.box-1 {
	border: 2px solid #CEE9FF;
	border-radius: 10px;
	margin-bottom: 20px;
}

.p-date {
	color: gray;
}

.border-bottom {
	color: rgb(237, 246, 255);
}

.tr {
	padding-bottom: 3px;
}

</style>
<title>파티 홈</title>
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
<div class="container my-3">
<%
	if ("req".equals(err)) {
%>
	
<%
	}
%>
<!-- 이어서 구현할 부분... -->
<%
	if (loginId != null && partyAccess != null) {
		if (partyAccess.getAuthNo() == 8 || partyAccess.getAuthNo() == 9) {
			
		}
%>
	<div style="margin-bottom: 10px;" class="text-end"> <!-- 글쓰기 버튼 -->
		<a href="form.jsp?no=<%=partyNo %>" class="btn btn-outline-primary btn-sm">글쓰기</a>
	</div>
	<div class="row mb-3 ">
<%
	}
%>
<%
	for (Board board : boards) {
%>
		<div class="col-12 box-1"> <!-- 게시물 박스 -->
 			<div>
	 			<table class="table table-borderless">
		 				<colgroup>
		 					<col width="85%">
		 					<col width="10%">
		 					<col width="5%">
		 				</colgroup>
		 			<tbody>
		 				<tr>
		 					<td><strong><%=board.getTitle() %></strong></td>
		 					<td><%=board.getUser().getNickname() %></td>
		 					<td>
		 						<div class="dropdown">
				 				<a class="btn dropdown-toggle "  href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"></a>
							  	<ul class="dropdown-menu">
								    <li><a class="dropdown-item" href="#">글 수정</a></li>
								    <li><a class="dropdown-item" href="#">삭제하기</a></li>
								    <li><a class="dropdown-item" href="#">신고하기</a></li>
							 	 </ul>
								 </div>	
		 					</td>
		 				</tr>
		 				<tr class="border-bottom">
		 					<td class="p-date"><%=board.getUpdateDate() %></td>
		 				</tr>
		 			</tbody>
	 			</table>
 			</div>
 			<div class="mt-3">
 				<img src="<%=request.getContextPath() %>/resources/board/sample.jpg" alt="첨부파일">
 				<p><%=board.getContent() %></p>
 			</div>
 			<div>
 				<p>댓글 5</p>
 			</div>
		</div> <!-- 게시물 박스 닫힘 -->
<%
	}
%>
	</div>
</div>
</body>
</html>