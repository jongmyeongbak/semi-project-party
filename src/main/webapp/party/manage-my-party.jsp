<%@page import="dao.UserPartyDtoDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="java.util.List"%>
<%@page import="dto.UserPartyDto"%>
<%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
//비로그인 경우 제외
String loginId = (String) session.getAttribute("loginId");
String contextPath = request.getContextPath();
if (loginId == null) {
	out.println("<script>alert('로그인이 필요합니다.');</script>");
	response.sendRedirect(contextPath + "/login-form.jsp?redirect=party/manage-my-party.jsp");
	return;
}

List<UserPartyDto> partyList = UserPartyDtoDao.getInstance().getAllMyParties(loginId);
%>
<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="css/manage-my-party.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/46a6014d50.js" crossorigin="anonymous"></script>
<script defer src="js/manage-my-party.js"></script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="home"/>
</jsp:include>
<div class="blank mb-3">
</div>
<div class="container">
	<div class="text-center">
		<h3>내 파티 목록을 확인하세요</h3>
	</div>
	<div class="party-box py-5 px-5 my-5">
		<div class="party-container px-5">
			<div class="tabs mb-3 px-5 pt-5">
				<div class="tab active" id="join">가입 파티</div>
				<div class="tab" id="favorite">즐겨찾는 파티</div>
				<div class="tab" id="managed">운영 파티</div>
			</div>
			<div class="party-content px-5 pb-5">
				<table class="table">
					<colgroup>
						<col width="10%">
						<col width="70%">
						<col width="20%">
						</colgroup>
					<thead>
						<tr>
							<th>즐겨찾기</th>
							<th>파티명</th>
							<th>탈퇴버튼</th>
						</tr>
					</thead>
					<tbody id="party-container">
					<%
					if (partyList.isEmpty()) {
					%>
						<tr><td colspan="3">가입한 파티가 없습니다.</td></tr>
					<%
					} else {
					%>
					<%
						for (UserPartyDto dto : partyList) {
							int no = dto.getNo();
					%>
						<tr data-no="<%=no %>">
							<td><i class="<%=dto.getIsFavorite() ? "fa-solid" : "fa-regular" %> fa-star fa-lg"></i></td>
							<td><img src="/images/thumbnail/<%=dto.getFilename() == null ? "sample.jpg" : dto.getFilename() %>"><a href="board/home.jsp?no=<%=no %>"><%=dto.getName() %></a></td>
							<td>
							<%
							if (dto.getIsManaged() == true) {
							%>
								<button type="button" class="manage">관리</button>
							<%
							} else {
							%>
								<button type="button" class="withdraw">탈퇴</button>
							<%
							}
							%>
							</td>
						</tr>
					<%
						}
					}
					%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
</html>