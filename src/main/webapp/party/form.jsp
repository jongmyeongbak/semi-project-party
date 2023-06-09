<%@page import="java.time.LocalDate"%>
<%@page import="util.StringUtils"%>
<%@page import="dao.PartyCategoryDao"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");
	String err = request.getParameter("err");
	int catNo = StringUtils.stringToInt(request.getParameter("cat"));
	// 로그인 된 상태가 아니라면 로그인 폼으로 돌려보냄
	if (loginId == null) {
		response.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 개설", "utf-8"));
		return;
	}
	// 파티의 카테고리를 불러온다.
	PartyCategoryDao partyCategoryDao = PartyCategoryDao.getInstance();
	List<Category> categoryList = partyCategoryDao.getAllCategories();
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<style>
		img {
			width: 100%;
			height: 100%;
			object-fit: contain;
		}
		.bs, .be {
			width: 35%;
		}
	</style>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="partylist" name="menu"/>
</jsp:include>
<div class="container">
	<div class="row mb-3">
		<div class="col">
			<p class="fs-5">파티 정보를 입력하고 개설하세요.</p>
			<form class="border bg-light row p-3" method="post" action="insert" enctype="multipart/form-data">
<%
	if ("name".equals(err)) {
%>
				<div class="alert alert-warning mt-1" role="alert">
 					같은 이름의 파티가 존재합니다. 파티명을 다시 작성해주세요
				</div>
<%
	}
	if ("cat".equals(err)) {
%>
				<div class="alert alert-warning mt-1" role="alert">
 					카테고리를 선택해주세요.
				</div>
<%
	}
%>
				<div class="form-group mb-3 col-6">
					<label class="form-label">카테고리</label>
					<select name="partyCat" class="form-control" required="required">
						<option id="noCat" selected disabled>카테고리를 고르세요</option>
<%
	for (Category category : categoryList) {
		if (catNo == 0) {
%>
						<option value="<%=category.getNo() %>"><%=category.getName() %></option>
<%
		} else {
%>
						<option value="<%=category.getNo() %>" <%=category.getNo() == catNo ? "selected" : "" %>><%=category.getName() %></option>
<%
		}
	}
%>
					</select>
				</div>
				<div class="form-group mb-3 col-6">
					<label class="form-label">파티명</label>
					<input type="text" name="partyName" class="form-control" required="required">
				</div>
				<div class="mb-3 col-6">
					<div class="form-group mb-3">
						<label class="form-label">최대정원</label>
						<input placeholder="최대 1000명" class="form-control" type="number" min="10" max="1000" step="10" name="partyQuota" required="required">
					</div>
					<div class="form-group mb-3">
						<label class="form-label">가입조건</label>
						<div class="form-check form-switch" id="req-group">
							<div class="row" id="req">
								<div class="col-7">
									<input class="form-check-input" type="checkbox" name="reqAge" id="reqAge" role="switch" value="나이">
									<label class="form-check-label" for="reqAge">나이</label>
									<div class="row">
										<select class="bs form-control me-2" name="birthStart" id="birthStart" disabled>
											<option value="" selected>제한없음</option>
<%
	LocalDate now = LocalDate.now();
	int year = now.getYear();
	for (int i = 1940; i <= year; i++){
%>
											<option value="<%=i %>"><%=i %>년생</option>
<%
	}
%>
										</select>
										<span class="col-1"> ~ </span>
										<select class="be form-control ms-2" name="birthEnd" id="birthEnd" disabled>
											<option value="" selected>제한없음</option>
<%
	for (int i = year; i >= 1940; i--){
%>
											<option value="<%=i %>"><%=i %>년생</option>
<%
	}
%>
									</select>
									</div>
								</div>
								<div class="col">
									<input class="form-check-input" type="checkbox" name="reqGen" id="reqGen" role="switch" value="성별">
									<label class="form-check-label" for="reqGen">성별</label>
									<select name="gender" id="gender" class="form-control w-75" disabled>
										<option value="M">남</option>
										<option value="F">여</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group mb-3 col-6">
					<label class="form-label">파티설명</label>
					<textarea class="form-control" name="partyDescription" cols="10" rows="5"></textarea>
				</div>
				<div class="col-6">
					<div class="form-group mb-3 col">
						<label class="form-label">썸네일 이미지</label>
						<p style="font-size: 15px; font-style: italic; font-weight: lighter;"><span style="font-weight: bolder; color: #555;">.jpg, .jpeg, .png</span> 형식의 75x75 사진파일</p>
						<input class="form-control" type="file" name="partyImage" id="inputImage">
					</div>
				</div>
				<div class="col-6">
					<p>썸네일 예시</p>
					<div class="col-6" style="margin:auto;" id="showimage">
						<img src="/resources/thumbnail/sample.jpg" alt="">
					</div>	
				</div>
				<div class="text-end">
					<button type="submit" class="btn btn-primary">만들기</button>
				</div>
			</form>
		</div>
	</div>
</div>
	<script>
		let showimage = document.querySelector("#showimage");
		let inputImage = document.querySelector("#inputImage");
		let img = document.querySelector("#showimage > img");
		let reqAge = document.querySelector("#reqAge");
		let reqGen = document.querySelector("#reqGen");
		let bs = document.querySelector("#birthStart");
		let be = document.querySelector("#birthEnd");
		let gender = document.querySelector("#gender");

		reqAge.addEventListener("change", () => {
			if (reqAge.checked){
				bs.disabled = false;
				be.disabled = false;
			} else {
				bs.disabled = true;
				be.disabled = true;
			}
		})
		reqGen.addEventListener("change", () => {
			if (reqGen.checked){
				gender.disabled = false;
			} else {
				gender.disabled = true;
			}
		})

		function readImage(input) {
			// 인풋 태그에 파일이 있는 경우
			if(input.files && input.files[0]) {
				// FileReader 인스턴스 생성
				const reader = new FileReader()
				// 이미지가 로드가 된 경우
				reader.onload = e => {
					img.src = e.target.result;
				}
				// reader가 이미지 읽도록 하기
				reader.readAsDataURL(input.files[0])
			}
		}
		// 변경사항이 일어나면 이미지를 읽어온다.
		inputImage.addEventListener("change", e => {
			readImage(e.target);
		})
		</script>
</body>
</html>