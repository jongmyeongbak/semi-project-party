<%@page import="info.Pagination"%>
<%@page import="vo.Party"%>
<%@page import="dao.PartyDao"%>
<%@page import="dao.PartyAccessDao"%>
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
	// 스크립트에서 로그인 여부에 따른 드롭메뉴 표시에 사용할 변수
	boolean isLoggedIn = loginId != null ? true : false;
	
	// 파티 번호 조회
	int partyNo = StringUtils.stringToInt(request.getParameter("no"));
	
	// 에러 코드 조회
	String err = request.getParameter("err");
	String job = request.getParameter("job");
	
	// 각 파티에 저장된 게시글 불러오기
	BoardDao boardDao = BoardDao.getInstance();
	int totalRows = boardDao.getBoardsTotalRowsByPartyNo(partyNo);
	
	// 무한 스크롤에 사용될 
	int pageNum = 1;
	Pagination pagination = new Pagination(pageNum, totalRows);
	List<Board> boards = boardDao.getBoardsByPartyNo(partyNo, pagination.getFirstRow(), pagination.getLastRow());
	
	// 글쓰기 버튼 노출을 위해 해당 파티에 가입된 사용자인지 확인
	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
	Integer authNo = null;
	if (loginId != null) {
		authNo =  partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);	
	}
	
	// 생성되지 않은 파티에 대한 리디렉트
	PartyDao partyDao = PartyDao.getInstance();
	Party party = partyDao.getPartyByNo(partyNo);
	if (party == null) {
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("파티 홈으로 가기", "UTF-8"));
		return;
	}
%>
<!doctype html>
<html lang="ko">
<head>
<title>파티 홈</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="../css/partyhome.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
</head>
<body>
<jsp:include page="../../nav.jsp">
	<jsp:param value="home" name="pmenu"/>
</jsp:include>
<div class="container my-3">
<jsp:include page="../intro.jsp">
	<jsp:param value="<%=partyNo %>" name="no"/>
</jsp:include>
<%
	if ("req".equals(err)) {
%>
	<div class="alert alert-danger">
		<strong>[<%=job %>]</strong> 에 대한 요청은 거부되었습니다.
	</div>
<%
	}
%>
<!-- 로그인이 되어있고 파티에 가입이 되어있으면서 유저의 접근권이 강퇴, 또는 탈퇴 상태가 아닐 때 글쓰기 버튼 노출 -->
<%
	if (loginId != null && authNo != null) {
		if (authNo < 8) {
%>
	<div style="margin-bottom: 10px;" class="text-end"> <!-- 글쓰기 버튼 -->
		<a href="form.jsp?partyNo=<%=partyNo %>" class="btn btn-outline-primary btn-sm" id="insert-btn">글쓰기</a>
	</div>
<%
		}
	}
%>

<div id="post-data">
<%
	for (Board board : boards) {
%>
 <div class="card" id="card-outline"> <!-- 게시물 시작 -->
		<div class="card-body">
		    <div class="d-flex justify-content-between align-items-center">
		     	<div>
			        <h5 class="card-title"><%=board.getTitle() %></h5>
			        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted"><%=board.getCreateDate() %></small></p>
		      	</div>
		      	<div class="d-flex align-items-center">
			    	<p class="card-text mr-2"><small><%=board.getUser().getNickname() %></small></p>
			    	
<!-- 자신이 쓴 게시물인지 아닌지에 따라 드롭다운 메뉴가 다름 -->
<!-- 본인이 작성한 게시물이고 유저 접근권한이 강퇴나 탈퇴가 아닐 때 -->
<%
	if (loginId != null && loginId.equals(board.getUser().getId()) && authNo < 8) {
%>
			        <div class="dropdown" style="position: relative; top: -5px;">
		          		<a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
		          		<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
		            		<li><a class="dropdown-item" href="modify-form.jsp?boardNo=<%=board.getNo() %>&partyNo=<%=partyNo %>">수정</a></li>
		            		<li><a class="dropdown-item" href="delete.jsp?boardNo=<%=board.getNo() %>&partyNo=<%=partyNo %>" onclick="return confirm('게시된 글을 삭제하시겠습니까?')">삭제</a></li>
		          		</ul>
		   			</div>
<%
	} else {
		if (loginId != null) {
%>
<!-- 남이 작성한 게시물일 때 -->

					<div class="dropdown" style="position: relative; top: -5px;">
			          		<a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
			          		<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
			            		<li><a class="dropdown-item" href="">신고</a></li>
			          		</ul>
			   		</div>
<%	
		}
	}
%>
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
		<!-- 댓글 -->
		<div class="row mb-3">
   		<div class="col-12">

   			<div class="border p-2 mb-2">
	   			<div class="d-flex justify-content-between mb-1">
	   				<span>홍길동</span> <span class="text-muted">2023-06-18</span>
	   			</div>
	   			<div>
	   				댓글내용입니다.
	   				<a href="deleteComment.jsp?no=&cno="class="btn btn-link text-danger text-decoration-none float-end"><i class="bi bi-trash"></i></a>
	   		 </div>   			
   			</div>

   		</div>
   	</div>
   	<!-- 댓글 닫힘 -->
	</div> <!-- 게시물 닫힘 -->
<%
	}
%>
</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">

$(window).scroll(function() {
	if($(window).scrollTop() + $(window).height() == $(document).height()) {
	loadMoreBoards();
	}
});
	let partyNo = <%=partyNo %>
	let pageNum = <%=pageNum %> +1 // 페이지 번호
	let authNo = <%=authNo %> // 유저의 파티 접근권한이 강퇴나 탈퇴시를 구별하기 위한 권한 번호
	let isLoggedIn = <%=isLoggedIn %> // 로그인이 되어있지 않으면 드롭메뉴 표시하지 않기위해 로그인 여부 확인 변수
	
	function loadMoreBoards() {
		$.ajax({
		    url: "load-more-boards.jsp?pageNum=" + pageNum + "&partyNo=" + partyNo,
		    type: "GET",
		    dataType: "json"
		}).done(function(response) {
		    //console.log(response); // json으로 변환된 텍스트가 자바스크립트 객체로 변환되어 오고 있나 확인
		    let htmlContents = "";
		  	response.forEach(function (item, index) {
		  		if (item[1] && authNo < 8) {
		  		// 로그인 유저와 작성자 아이디가 같을 때 
		  		htmlContents += `
		    	<div class="card" id="card-outline">
		            <div class="card-body">
		                <div class="d-flex justify-content-between align-items-center">
		                    <div>
		                        <h5 class="card-title">\${item[0].title}</h5>
		                        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted">\${item[0].createDate}</small></p>
		                    </div>
		                    <div class="d-flex align-items-center">
		                        <p class="card-text mr-2"><small>\${item[0].user.nickname}</small></p>
		                        <!-- 자신의 게시글일 때 드롭다운 메뉴 -->
		    			        <div class="dropdown" style="position: relative; top: -5px;">
				          			<a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
				          			<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
				            			<li><a class="dropdown-item" href="modify-form.jsp?boardNo=\${item[0].no}&partyNo=\${item[0].party.no}">수정</a></li>
				            			<li><a class="dropdown-item" href="delete.jsp?boardNo=\${item[0].no}&partyNo=\${item[0].party.no}" onclick="return confirm('게시된 글을 삭제하시겠습니까?')">삭제</a></li>
				          			</ul>
				   				</div>
		                    </div>
		                </div>
		                \${item[0].filename ? `<img src="/images/board/\${item[0].filename}" class="img-fluid" alt="게시물 이미지">` : ""}
		                <p class="card-text">\${item[0].content}</p>
		                <p class="card-text"><small class="text-muted">댓글 \${item[0].commentCnt}</small></p>
		            </div>
		        </div>
		        `
		  		} else {
		  		htmlContents += `
		  			<div class="card" id="card-outline"> <!-- 게시물 시작 -->
		  			<div class="card-body">
		  			    <div class="d-flex justify-content-between align-items-center">
		  			     	<div>
		  				        <h5 class="card-title">\${item[0].title}</h5>
		  				        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted">\${item[0].createDate}</small></p>
		  			      	</div>
		  			      	<div class="d-flex align-items-center">
		  				    	<p class="card-text mr-2"><small>\${item[0].user.nickname}</small></small></p>
		  						<!-- 남이 작성한 게시물일 때 드롭다운 메뉴- 로그인 여부에 따라 출연여부 다름 -->
					  			 \${isLoggedIn ?
				                `<div class="dropdown" style="position: relative; top: -5px;">
				                    <a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
				                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
				                        <li><a class="dropdown-item" href="">신고</a></li>
				                    </ul>
				                </div>` : ""}
		  					</div>
		  				</div>
		  				 \${item[0].filename ? `<img src="/images/board/\${item[0].filename}" class="img-fluid" alt="게시물 이미지">` : ""}
		  			    <p class="card-text">\${item[0].content}</small></p>
		  			    <p class="card-text"><small class="text-muted">댓글 \${item[0].commentCnt}</small></p>
		  			</div>
		  		</div> <!-- 게시물 닫힘 -->
		  		`
		  		}
		  	});
			$("#post-data").append(htmlContents); // 불러온 데이터를 기존 게시글 뒤에 붙임
		    pageNum++; // 페이지 번호 증가
		    console.log(response);
		}).fail(function(jqXHR, ajaxOptions, thrownError) {
		    console.log('Server error occured');
		});
	}
</script>
</body>
</html>