<%@page import="vo.Comment"%>
<%@page import="dao.CommentDao"%>
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
	
	// 각 파티에 저장된 게시글, 댓글 불러오기
	BoardDao boardDao = BoardDao.getInstance();
	CommentDao commentDao = CommentDao.getInstance();
	
	// 일정 범위내 게시물과 댓글 불러오기
	int pageNum = 1;
	int totalRows = boardDao.getBoardsTotalRowsByPartyNo(partyNo);
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
<style type="text/css">
.hidden {
	display: none;
}
</style>
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
	} else if ("id".equals(err)) {
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
		    <p class="card-text" style= "white-space: break-spaces;"><%=board.getContent() %></p>
		    <p class="card-text" >
		    	<small class="text-muted">댓글 <%=board.getCommentCnt() %></small>
		    	<i class="bi bi-chevron-down more-button" onclick="moreComments(<%=board.getNo()%>); this.onclick=null;" style="cursor: pointer;"></i>
			</p>
			
		</div>

<!-- 댓글 창 -->
    <div class="col-12">
<% 
	List<Comment> comments = commentDao.getCommentsByBoardNo(board.getNo());
	int index = 0;
	for (Comment comment : comments) {
%>
        <div id="comments<%=board.getNo()%><%=index%>">
                <div class="col-12">
                    <div class="border p-2 mb-2">
                        <div class="d-flex justify-content-between mb-1" >
                            <span><%=comment.getUser().getNickname() %></span>
                            <span class="text-muted"><%=comment.getCreateDate() %></span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <p style= "white-space: break-spaces;"><%=comment.getContent() %></p>
<%
		if (loginId != null) {
			if (loginId.equals(comment.getUser().getId())) {
%>
						<div>
                            <a href="delete-comment.jsp?bno=<%=board.getNo() %>&cno=<%=comment.getNo() %>" class="btn btn-link text-danger text-decoration-none float-end" 
                                onclick="return confirm('댓글을 삭제하시겠습니까?')" >
                            	<i class="bi bi-trash"></i>
                            </a>
                            <a href="#" class="btn btn-link text-muted text-decoration-none float-end">
   								<i class="bi bi-pencil"></i>
							</a>
						</div>	
<%
			}
		} 
%>                           
                        </div>
                    </div>
                </div>
	        </div>
<% 
	index++;
	}
%>
    </div>
   	<!-- 댓글 닫힘 -->
    <!-- 댓글 폼 -->
		<div class="row mb-3">
	   		<div class="col-12">
				<form class="border bg-light p-2" method="post" action="insert-comment.jsp">
					<input type="hidden" name="boardNo" value="<%=board.getNo() %>" />
					<input type="hidden" name="partyNo" value="<%=board.getParty().getNo() %>" />
	 				<div class="row">
						<div class="col-11">
							<textarea rows="2" class="form-control" name="content"></textarea>
						</div>
						<div class="col-1">
							<button class="btn btn-outline-primary h-100">등록</button>
						</div>
					</div>
				</form>   	
	   		</div>
	   	</div>
	</div> <!-- 게시물 닫힘 -->
<%
	}
%>
</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script type="text/javascript">
	
	let partyNo = <%=partyNo %>;
	let pageNum = <%=pageNum%> +1 ; // 페이지 번호
	let authNo = <%=authNo %>; // 유저의 파티 접근권한이 강퇴나 탈퇴시를 구별하기 위한 권한 번호
	let isLoggedIn = <%=isLoggedIn %>; // 로그인이 되어있지 않으면 드롭메뉴 표시하지 않기위해 로그인 여부 확인 변수
	
	$(window).scroll(function() {
		if($(window).scrollTop() + $(window).height() == $(document).height()) {
		loadMoreBoards();
		}
	});

	function loadMoreBoards() {
		$.ajax({
		    url: "load-more-boards.jsp?pageNum=" + pageNum + "&partyNo=" + partyNo,
		    type: "GET",
		    dataType: "json"
		}).done(function(response) {
		    console.log(response); // json으로 변환된 텍스트가 자바스크립트 객체로 변환되어 오고 있나 확인
		    let htmlContents = "";
		  	response.forEach(function (boardsCommentsIsMine, index) {
			    let board = boardsCommentsIsMine["board"];
		  		let isMine = boardsCommentsIsMine["isMine"];
		  		let comments = boardsCommentsIsMine["comments"];
		  		if (isMine && authNo < 8) {
		  		// 로그인 유저와 작성자 아이디가 같을 때 
		  		htmlContents += `
		    	<div class="card" id="card-outline">
		            <div class="card-body">
		                <div class="d-flex justify-content-between align-items-center">
		                    <div>
		                        <h5 class="card-title">\${board.title}</h5>
		                        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted">\${board.createDate}</small></p>
		                    </div>
		                    <div class="d-flex align-items-center">
		                        <p class="card-text mr-2"><small>\${board.user.nickname}</small></p>
		                        <!-- 자신의 게시글일 때 드롭다운 메뉴 -->
		    			        <div class="dropdown" style="position: relative; top: -5px;">
				          			<a class="btn dropdown-toggle more-button" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false"></a>
				          			<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
				            			<li><a class="dropdown-item" href="modify-form.jsp?boardNo=\${board.no}&partyNo=\${board.party.no}">수정</a></li>
				            			<li><a class="dropdown-item" href="delete.jsp?boardNo=\${board.no}&partyNo=\$board.party.no}" onclick="return confirm('게시된 글을 삭제하시겠습니까?')">삭제</a></li>
				          			</ul>
				   				</div>
		                    </div>
		                </div>
		                \${board.filename ? `<img src="/images/board/\${board.filename}" class="img-fluid" alt="게시물 이미지">` : ""}
		                <p class="card-text" style= "white-space: break-spaces;">\${board.content}</p>
		    		    <p class="card-text">
		    		    	<small class="text-muted">댓글 \${board.commentCnt}</small>
		    		    	<i class="bi bi-chevron-down more-button" onclick="moreComments(\${board.no}); this.onclick=null;" style="cursor: pointer;"></i>
		    			</p>
		    		</div>
		        `
		  		} else {
		  		htmlContents += `
		  			<div class="card" id="card-outline"> <!-- 게시물 시작 -->
		  			<div class="card-body">
		  			    <div class="d-flex justify-content-between align-items-center">
		  			     	<div>
		  				        <h5 class="card-title">\${board.title}</h5>
		  				        <p class="card-text" style="margin-bottom: 10px;"><small class="text-muted">\${board.createDate}</small></p>
		  			      	</div>
		  			      	<div class="d-flex align-items-center">
		  				    	<p class="card-text mr-2"><small>\${board.user.nickname}</small></small></p>
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
		  				\${board.filename ? `<img src="/images/board/\${board.filename}" class="img-fluid" alt="게시물 이미지">` : ""}
		                <p class="card-text" style= "white-space: break-spaces;">\${board.content}</p>
		    		    <p class="card-text">
		    		    	<small class="text-muted">댓글 \${board.commentCnt}</small>
		    		    	<i class="bi bi-chevron-down more-button" onclick="moreComments(\${board.no}); this.onclick=null;" style="cursor: pointer;"></i>
		    			</p>
		    		</div>
		  		`
		  		}
		  	    comments.forEach(function (comment, index) {
		  	    	// 무한로딩으로 추가되는 게시물 중 2개의 댓글에 대한 로그인 유저와 일치 여부
		  	    	if (comment[1]) {
		  	        htmlContents += `
        	        <div id="comments\${board.no}\${index}">
        	                <div class="col-12">
        	                    <div class="border p-2 mb-2">
        	                        <div class="d-flex justify-content-between mb-1" >
        	                            <span>\${comment[0].user.nickname}</span>
        	                            <span class="text-muted">\${comment[0].createDate}</span>
        	                        </div>
        	                        <div class="d-flex justify-content-between">
        	                            <p style= "white-space: break-spaces;">\${comment[0].content}</p>
        	                            \${isLoggedIn ?
										`<div>
        	                            	<a href="delete-comment.jsp?bno=\${board.no}&cno=\${comment[0].no}" class="btn btn-link text-danger text-decoration-none float-end"
        	                             		onclick="return confirm('댓글을 삭제하시겠습니까?')">
        	                            		<i class="bi bi-trash"></i>
        	                             	</a>
        	                             	<a href="#" class="btn btn-link text-muted text-decoration-none float-end">
        	   									<i class="bi bi-pencil"></i>
        									</a>
        								 </div>` : ""}
        	                        </div>
        	                    </div>
        	                </div>
        	            </div>`;
		  	    	} else {
		  	    		htmlContents += `
		  	    		<div id="comments\${board.no}\${index}">
        	                <div class="col-12">
        	                    <div class="border p-2 mb-2">
        	                        <div class="d-flex justify-content-between mb-1" >
        	                            <span>\${comment[0].user.nickname}</span>
        	                            <span class="text-muted">\${comment[0].createDate}</span>
        	                        </div>
        	                        <div>
        	                        	<p style= "white-space: break-spaces;">\${comment[0].content}</p>
        	                        </div>
        	                    </div>
        	                </div>
        	            </div>`;
		  	    	}
	  	  		  });
		  	    htmlContents += `
		  	        <div class="row mb-3" id="comment-form\${board.no}">
		  	            <div class="col-12">
		  	                <form class="border bg-light p-2" method="post" action="insert-comment.jsp?partyNo=\${partyNo}">
		  	                    <input type="hidden" name="boardNo" value="\${board.no}" />
		  	                    <div class="row">
		  	                        <div class="col-11">
		  	                            <textarea rows="2" class="form-control" name="content"></textarea>
		  	                        </div>
		  	                        <div class="col-1">
		  	                            <button class="btn btn-outline-primary h-100">등록</button>
		  	                        </div>
		  	                    </div>
		  	                </form>     
		  	            </div>
		  	        </div>
		  	    </div>`;
		  	});
		  	
			$("#post-data").append(htmlContents); // 불러온 데이터를 기존 게시글 뒤에 붙임
		    pageNum++; // 페이지 번호 증가
		    
		}).fail(function(jqXHR, ajaxOptions, thrownError) {
		    console.log('Server error occured');
		});
	}
	function moreComments(no) {
		// 처음에 보여주는 2개의 댓글 외에 출력되는 나머지 전체 댓글
		$.ajax({
		    url: "load-more-comments.jsp?boardNo=" + no,
		    type: "GET",
		    dataType: "json"
		}).done(function(response) {
		    console.log(response); // json으로 변환된 텍스트가 자바스크립트 객체로 변환되어 오고 있나 확인
		    let htmlContents = "";
		    response.forEach(comments =>{
		    	let comment = comments["comments"];
		    	let isMine = comments["isMine"];
			    if (isMine) {
			    	// 내 댓글일 때
			    	htmlContents += `
		    		<div id="comments" class="collapse show comments">
    	                <div class="col-12">
    	                    <div class="border p-2 mb-2">
    	                        <div class="d-flex justify-content-between mb-1" >
    	                            <span>\${comment.user.nickname}</span>
    	                            <span class="text-muted">\${comment.createDate}</span>
    	                        </div>
    	                        <div class="d-flex justify-content-between">
    	                   		    <p style= "white-space: break-spaces;">\${comment.content}</p>
    	                            \${isLoggedIn ? 
   	                            	`<div>
    	                            	<a href="delete-comment.jsp?bno=\${no}&cno=\${comment.no}" class="btn btn-link text-danger text-decoration-none float-end" onclick="return confirm('댓글을 삭제하시겠습니까?')">
    	                            		<i class="bi bi-trash"></i>
	                           			</a>
	                         			<a href="#" class="btn btn-link text-muted text-decoration-none float-end">
	   										<i class="bi bi-pencil"></i>
    									</a>
    								 </div>` : ""}
    	                        </div>
    	                    </div>
    	                </div>
    	            </div>
			    	`
			    } else {
			    // 내 댓글이 아닐 때	
			    	htmlContents += `
		    		<div id="comments" class="collapse show comments">
    	                <div class="col-12">
    	                    <div class="border p-2 mb-2">
    	                        <div class="d-flex justify-content-between mb-1" >
    	                            <span>\${comment.user.nickname}</span>
    	                            <span class="text-muted">\${comment.createDate}</span>
    	                        </div>
    	                        <div>
    	                       		<p style= "white-space: break-spaces;">\${comment.content}</p>
    	                        </div>
    	                    </div>
    	                </div>
    	            </div>
			    	`
			    }
		    })
		    $("#comments" + no + "1").append(htmlContents);
			// 토글로 댓글을 숨기고 보여주기 설정
			document.querySelectorAll(".more-button").forEach(function(button) {
			    button.addEventListener("click", function() {
			    	console.log("click");
			    	 let comments = button.closest('.card').querySelectorAll('.comments');
			        for (let i = 0; i < comments.length; i++) {
			            comments[i].classList.toggle('hidden');
			        }
			        button.classList.toggle('bi-chevron-up');
			    });
			});
		}).fail(function(jqXHR, ajaxOptions, thrownError) {
		    console.log('Server error occured');
		});
	}
</script>
</body>
</html>