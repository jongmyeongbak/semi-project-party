<%@page import="dao.PartyReqDao"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="vo.PartyAccess"%>
<%@page import="dao.PartyDao"%>
<%@page import="vo.Party"%>
<%@page import="java.time.LocalDate"%>
<%@page import="util.StringUtils"%>
<%@page import="dao.PartyCategoryDao"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
// 로그인된 아이디 조회
	String loginId = (String) session.getAttribute("loginId");
	// 파티 번호 조회
	int no = StringUtils.stringToInt(request.getParameter("no"));
	String err = request.getParameter("err");
	// 로그인 된 상태가 아니라면 로그인 폼으로 돌려보냄
	if (loginId == null) {
		response.sendRedirect("../login-form.jsp?err=req&job=" + URLEncoder.encode("파티 수정", "utf-8"));
		return;
	}
	// 해당 파티의 운영자가 아니라면 돌려보낸다.
	PartyAccessDao userPartyAccessDao = PartyAccessDao.getInstance();
	// 아이디와 파티번호로 유저의 파티접근권 정보를 가져온다.
	Integer authNo = userPartyAccessDao.getAuthNoByPartyNoAndUserId(no, loginId);
	// 해당 파티의 운영자가 아니면 오류메세지와 함께 돌려보낸다.
	if (authNo == null || authNo != 6) {
		response.sendRedirect("home.jsp?err=req&job=" + URLEncoder.encode("파티 수정", "utf-8"));
		return;
	}
	PartyDao partyDao = PartyDao.getInstance();
	Party savedParty = partyDao.getPartyWithCategoryByNo(no);
	PartyReqDao partyReqDao = PartyReqDao.getInstance();
	List<String> valueList = partyReqDao.getValuesByNo(no);
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
			width: 53%;
		}
	</style>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="home" name="pmenu"/>
</jsp:include>
<div class="container">
	<div class="row mb-3">
		<div class="col">
			<p class="fs-5">파티 정보를 확인하고 수정하세요.</p>
			<form class="border bg-light row p-3" method="post" action="modify" enctype="multipart/form-data">
			<input type="hidden" value="<%=savedParty.getNo() %>" name="no">
<%
	if ("name".equals(err)) {
%>
				<div class="alert alert-warning mt-1" role="alert">
 					같은 이름의 파티가 존재합니다. 파티명을 다시 작성해주세요
				</div>
<%
	}
%>
				<div class="form-group mb-3 col-6">
					<label class="form-label">카테고리</label>
					<select name="partyCat" class="form-control" disabled>
						<option value="<%=savedParty.getCategory().getNo() %>"><%=savedParty.getCategory().getName() %></option>
					</select>
				</div>
				<div class="form-group mb-3 col-6">
					<label class="form-label">파티명</label>
					<input type="text" name="partyName" class="form-control" required="required" value="<%=savedParty.getName() %>">
				</div>
				<div class="mb-3 col-6">
					<div class="form-group mb-3">
						<label class="form-label">최대정원</label>
						<input placeholder="최대 1000명" class="form-control" type="number" min="10" max="1000" step="10" name="partyQuota" required="required" value="<%=savedParty.getQuota() %>">
					</div>
					<div class="form-group mb-3">
						<label class="form-label">가입조건</label>
						<div class="form-check form-switch" id="req-group">
							<div class="row" id="req">
								<div class="col-6">
									<div class="row mb-3">
										<label class="col-4 col-form-label" for="birthStart">최소 나이</label>
										<select class="col-8 bs form-control" name="birthStart" id="birthStart">
											<option value="9999">제한없음</option>
<%
	LocalDate now = LocalDate.now();
	int year = now.getYear();
	for (int i = year - 13; i > year - 100; i--){
%>
											<option value="<%=i %>" <%=StringUtils.stringToInt(valueList.get(0)) == i ? "selected" : "" %>><%=i %>년생 (만 <%=year - i %>세)</option>
<%
	}
%>
										</select>
									</div>
									<div class="row">
										<label class="col-4 col-form-label" for="birthEnd">최대 나이</label>
										<select class="col-8 be form-control" name="birthEnd" id="birthEnd">
											<option value="0000">제한없음</option>
<%
	for (int i = year - 13; i > year - 100; i--){
%>
											<option value="<%=i %>" <%=StringUtils.stringToInt(valueList.get(1)) == i ? "selected" : "" %>><%=i %>년생 (만 <%=year - i %>세)</option>
<%
	}
%>
									</select>
									</div>
								</div>
								<div class="col">
									<div class="row">
										<label class="col-3 col-form-label" for="gender">성별</label>
										<select name="gender" id="gender" class="form-control w-50 col-9">
											<option value="A" <%=valueList.get(2).equals("A") ? "selected" : "" %>>제한없음</option>
											<option value="M" <%=valueList.get(2).equals("M") ? "selected" : "" %>>남</option>
											<option value="F" <%=valueList.get(2).equals("F") ? "selected" : "" %>>여</option>
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group mb-3 col-6">
					<label class="form-label">파티설명</label>
					<textarea class="form-control" name="partyDescription" cols="10" rows="5"><%=savedParty.getDescription() == null ? "" : savedParty.getDescription() %></textarea>
				</div>
				<div class="col-6">
					<div class="form-group mb-3 col">
						<label class="form-label">썸네일 이미지</label>
						<p style="font-size: 15px; font-style: italic; font-weight: lighter;"><span style="font-weight: bolder; color: #555;">.jpg, .jpeg, .png</span> 형식의 75x75 사진파일</p>
						<input class="form-control" type="file" name="partyImage" id="inputImage" accept="image/jpeg, image/png">
					</div>
				</div>
				<div class="col-6">
					<p>썸네일 예시</p>
					<div class="col-6" style="margin:auto;" id="showimage">
						<img src="<%=request.getContextPath() %>/images/thumbnail/<%=savedParty.getFilename() %>" alt="파티대표사진">
					</div>	
				</div>
				<div class="text-end">
					<button type="submit" class="btn btn-primary">수정하기</button>
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