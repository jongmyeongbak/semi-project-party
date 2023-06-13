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
<title>파티 홈</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="../css/partyhome.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
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
<!-- 로그인이 되어있지 않거나, 유저의 파티 접근 권한이 강퇴, 탈퇴일 경우 파티 리스트로 리디렉트 -->
<%
	if (loginId != null && partyAccess != null) {
		if (partyAccess.getAuthNo() == 8 || partyAccess.getAuthNo() == 9) {
			response.sendRedirect("../list.jsp?err=deny&job=" + URLEncoder.encode("홈으로 가기", "UTF-8"));
		}
%>
	<div style="margin-bottom: 10px;" class="text-end"> <!-- 글쓰기 버튼 -->
		<a href="form.jsp?no=<%=partyNo %>" class="btn btn-outline-primary btn-sm" id="insert-btn">글쓰기</a>
	</div>
<%
	}
%>
<%
	for (Board board : boards) {
%>
    <div class="card" id="card-outline">
		<div class="card-body">
		    <div class="d-flex justify-content-between align-items-center">
		     	<div>
			        <h5 class="card-title"><%=board.getTitle() %></h5>
			        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted"><%=board.getUpdateDate() %></small></p>
		      	</div>
		      	<div class="d-flex align-items-center">
			    	<p class="card-text mr-2"><small><%=board.getUser().getNickname() %></small></p>
			        <div class="dropdown" style="position: relative; top: -5px;">
		          		<a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
		          		<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
		            		<li><a class="dropdown-item" href="#">수정</a></li>
		            		<li><a class="dropdown-item" href="#">삭제</a></li>
		          		</ul>
		   			</div>
				</div>
			</div>
<% 
	if (board.getFilename() != null) { %>
      <img src="/images/board/<%=board.getFilename() %>" class="img-fluid" alt="게시물 이미지">
<%
	}
%>
		    <p class="card-text"><%=board.getContent() %></p>
		    <p class="card-text"><small class="text-muted">댓글 <%=board.getCommentCnt() %></small></p>
		</div>
	</div>
<%
	}
%>
</div>

</body>
</html>