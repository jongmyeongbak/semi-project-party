<%@page import="dto.PaginationOld"%>
<%@page import="info.Pagination"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.Party"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.PartyListDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그인 회원아이디 세션 조회
	String loginId = (String) session.getAttribute("loginId");

	PartyListDao partyListDao = PartyListDao.getInstance();
	
	// 현재 페이지 조회
	int pageNo = StringUtils.stringToInt(request.getParameter("page"), 1);
	
	// 전체 행 조회
	int noUserPartyRows = partyListDao.getAllPartiesTotalRows(loginId);
	Pagination pagination = new Pagination(pageNo, noUserPartyRows);

	List<Category> categories = partyListDao.getCategories();
	List<Party> regParties = partyListDao.getUserRegPartiesByUserId(loginId);
	
	// 10개의 행 출력기준, 불러들일 첫 행과 마지막 행의 번호
	int firstRow = pagination.getFirstRow(), lastRow = pagination.getLastRow();
	
	List<Party> parties = partyListDao.getPartiesWithoutUser(loginId, firstRow, lastRow);
	List<Party> allParties = partyListDao.getAllParties(firstRow, lastRow);

%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">
.category-container {
    display: flex;
    justify-content: space-evenly;
    flex-wrap: wrap;
    margin-bottom: 50px;
}

/* 원형 아이템 안에 카테고리 이름이 들어가있는 형태, 카테고리에 따라 다른 이미지나 로고를 삽입하려면
	이미지 url컬럼이 필요함 */
.category-item {
    display: inline-block;
    margin-right: 20px;
    width: 130px;
    height: 130px;
    line-height: 130px;
    text-align: center;
    border-radius: 100%;
    background-color: rgb(237, 246, 255);
}

/* 내가 가입한 파티 컨테이너 css */
.regparty-container {
	
    display: grid;
    grid-template-columns: repeat(5, 2fr);
    background-color: rgb(237, 246, 255);
    padding-top: 15px;
}

/* 내가 가입한 파티 아이템 css */
.regparty-item {
	box-sizing: border-box;
	display: flex;
	flex-direction: column; 
	align-items: center;
	justify-content: flex-start;
	height: 230px;
	border-radius: 10%;
	background-color: #CEE9FF;
	margin-left: 18px;
	margin-right: 18px;
	margin-bottom: 15px;
}

/* 내가 가입한 파티 아이템 이미지 css */
.regparty-item img {
	width: 100%;
	height: 66%;
	justify-content: space-between;
	object-fit: cover;

}

/* 생성된 파티 컨테이너 */
.party-container {
    display: grid;
	grid-template-columns: repeat(2, 1fr);
    justify-content: center;
    background-color: rgb(237, 246, 255)
}

/* 생성된 파티 아이템 */
.party-item {
	display: inline-block;
	border-radius: 10%;
	width: 80%;
	float: left;
	
}

/* 생성된 파티 아이템 이미지 */
.party-item img {
	width: 100px;
	height: 100px;
	margin-bottom: 10px;
	margin-right: 15px;

}

/* h5태그 css */
.h5-content {
	margin: 1em;
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
<jsp:include page="../nav.jsp">
	<jsp:param value="partylist" name="파티리스트"/>
</jsp:include>
<div class="container">
<!-- 로그인 유저가 가입한 파티 조회 -->
<%
	if (loginId != null) {
		if (!regParties.isEmpty()) {
%>
<div>
	<div><h5>나의 파티</h5></div>
		<div class="regparty-container">
<%
			for (Party regParty : regParties) {
%>
					<a href="party-home.jsp?no=<%=regParty.getNo() %>" class="text-black text-decoration-none">
						<div class="regparty-item">
							<img class="regparty-item img" src="IMG_4834.jpg" alt="">
							<div>
								<strong><%=regParty.getName() %></strong>
								<p><%=regParty.getCurCnt() %>명</p>
							</div>
						</div>
					</a>
<%
			}
%>
		</div>
</div>

<%
		}
%>
<!-- 파티생성을 위한 카테고리 조회 -->
<div>
	<h5 class="h5-content">새로운 파티 만들기</h5>
		<div class="category-container">

<%
		for (Category category : categories) {
%>
				<div class="category-item">
					<a href="create-form.jsp?partyCat=<%=category.getNo()%>" class="text-black text-decoration-none">
						<strong>
							<span><%=category.getName()%></span>
						</strong>
						</a>
				</div>
<%
		}
%>
		</div>
</div>
<!-- 이어서 구현할 부분 -->
<!-- 로그인된 유저를 제외한 생성된 모든 파티 조회 -->
<div>
	<h5>이런 파티는 어때요</h5>
		<div class="party-container">
<%
		for (Party party : parties) {
%>
				<a href="party-home.jsp?no=" class="text-black text-decoration-none">
					<div class="party-item col-6">
						<img class="party-item img" src="IMG_4834.jpg" alt="">
						<div>
							<strong><%=party.getName() %></strong>
							<p><%=party.getDescription() %></p>
							<p><%=party.getCurCnt() %>명</p>
						</div>
					</div>
				</a>	
<%
		}
%>			
			</div>
	</div>
<%
	} else {
%>
<div>
	<h5>이런 파티는 어때요</h5>
		<div class="party-container">
<%
		for(Party party : allParties) {
%>
<!-- 이어서 구현할 부분 -->
<!-- 비로그인 상태에서 생성된 모든 파티 조회 -->

				<a href="party-home.jsp?no=" class="text-black text-decoration-none">
					<div class="party-item col-6">
						<img class="party-item img" src="IMG_4834.jpg" alt="">
						<div>
							<strong><%=party.getName() %></strong>
							<p><%=party.getDescription() %></p>
							<p><%=party.getCurCnt() %>명</p>
						</div>
					</div>
				</a>	
		
<%
		}
%>
		</div>
</div>
<%
	}
%>

	<div class="row mb-3">
		<div class="col-12">
			<nav>
				<ul class="pagination justify-content-center">
					<li class="page-item <%=pageNo <= 1 ? "disabled" : "" %>"><a class="page-link" href="list.jsp?page=1">이전</a></li>
<%
	for (int num = pagination.getFirstPageNoOnPageList(); num <= pagination.getLastPageNoOnPageList(); num++) {
%>
					<li class="page-item"><a class="page-link <%=pageNo == num ? "active" : "" %>" href="list.jsp?page=<%=num %>"><%=num %></a></li>
<%
	}
%>
					<li class="page-item "><a class="page-link <%=pageNo >= pagination.getTotalPages()? "disabled" : "" %>" href="list.jsp?page=<%=pageNo + 1 %>">다음</a></li>
				</ul>
			</nav>
		</div>
	</div>

</div>

</body>
</html>