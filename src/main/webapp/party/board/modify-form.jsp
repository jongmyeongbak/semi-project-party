<%@page import="dao.PartyAccessDao"%>
<%@page import="dao.BoardDao"%>
<%@page import="vo.Board"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	String loginId = (String) session.getAttribute("loginId");
	int boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));	
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));

	// 로그인이 되어있지 않은 경우 리디렉트
	if (loginId == null) {
		response.sendRedirect("../../login-form.jsp?err=req&job=" + URLEncoder.encode("게시글 수정", "UTF-8"));
		return;
	}
	
	// 수정할 게시물이 존재하지 않거나 로그인된 아이디와 게시물 작성자의 아이디가 일치하지 않으면 리디렉트
	BoardDao boardDao = BoardDao.getInstance();
	Board savedBoard = boardDao.getBoardByBoardNo(boardNo);
	if (savedBoard == null || !loginId.equals(savedBoard.getUser().getId())) {
		response.sendRedirect("../list.jsp?err=id&job=" + URLEncoder.encode("게시물 수정", "UTF-8"));
		return;
	}
	
	// 파티접근권 자체가 존재하지 않거나(파티에 가입한 적 없음) 유저 접근권의 상태가 강퇴나 탈퇴인 경우 파티 리스트로 리디렉트
	PartyAccessDao partyAccessDao = PartyAccessDao.getInstance();
	Integer authNo = partyAccessDao.getAuthNoByPartyNoAndUserId(partyNo, loginId);	
	if (authNo == null || authNo >= 8) {
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("게시글 수정", "UTF-8"));
		return;
	}
%>
<!doctype html>
<html lang="ko">
<head>
<style>
img {
	width: 100%;
	height: 100%;
	object-fit: contain;
}
</style>
<title></title>
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

<!-- 제목, 본문, 첨부파일 -->
<div class="container">
	<div class="row mb-3">
		<div class="col">
			<h5>파티에 게시물을 작성해보세요.</h5>
			<form class="border bg-light p-3" action="modify" method="post" enctype="multipart/form-data">
				<input type="hidden" name="boardNo" value="<%=savedBoard.getNo() %>"/> 
				<input type="hidden" name="partyNo" value="<%=savedBoard.getParty().getNo() %>"/> 
				<div class="form-group mb-2">
					<label class="form-label">제목</label>
					<input type="text" class="form-control" name="title" value="<%=savedBoard.getTitle() %>" required="required"/>
				</div>
				<div class="form-group mb-2" >
					<label class="form-label">내용</label>
					<textarea rows="5" class="form-control" name="content" required="required"><%=savedBoard.getContent() %></textarea>
				</div>
				<div class="col-6">
					<div class="form-group mb-3 col">
						<label class="form-label">첨부파일</label>
						<p style="font-size: 15px; font-style: italic; font-weight: lighter;"><span style="font-weight: bolder; color: #555;">.jpg, .jpeg, .png</span> 형식의 사진파일</p>
						<input class="form-control" type="file" name="boardImage" id="inputImage" accept="image/jpeg, image/png">
					</div>
				</div>
				<div class="col-6">
					<div class="col-6" style="margin:auto;" id="showimage">
						<img src="/images/board/<%=savedBoard.getFilename() %>" alt="샘플사진">
					</div>	
				</div>
				<div class="text-end">
					<button type="button" class="btn btn-secondary" onclick="confirm('작성 중인 내용이 저장되지 않고 사라집니다.') && history.back()">취소</button>
					<button type="submit" class="btn btn-primary" onclick="return confirm('수정한 게시물을 등록하시겠습니까?')">등록</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
let inputImage = document.querySelector("#inputImage");
let img = document.querySelector("#showimage > img");

/* 기존의 함수 선언식 작성을 함수 표현식으로 바꿈 */
let readImage = function(input) {
	// 인풋 태그에 파일이 있는 경우
	if(input.files && input.files[0]) {
		// 이미지 파일인지 확인
		if(!input.files[0].type.startsWith("image/")){
			alert("선택한 파일은 이미지 파일이 아닙니다.");
            input.value = ""
            return;
		}
		// 파일 크기 확인 (2MB 제한)
        let size = input.files[0].size / 1024 / 1024;
        if(size > 2) {
               alert("이미지 파일 크기가 너무 큽니다. 2MB 이하의 파일을 업로드 해주세요.");
               input.value = ""
               return;
		}
           
		// FileReader 인스턴스 생성
		const reader = new FileReader();
		// 이미지가 로드가 된 경우
		reader.onload = e => {
			img.src = e.target.result;
		};
		// reader가 이미지 읽도록 하기
		reader.readAsDataURL(input.files[0]);
	}
}
//변경사항이 일어나면 이미지를 읽어온다.
inputImage.addEventListener("change", e => {
	readImage(e.target);
})

</script>
</body>
</html>