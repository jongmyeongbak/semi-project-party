<%@page import="vo.Party"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.PartyListDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");
	PartyListDao partyListDao = PartyListDao.getInstance();
	
	List<Category> categories = partyListDao.getCategories();
	List<Party> regParties = partyListDao.getUserRegPartiesByUserId(loginId);
	List<Party> parties = partyListDao.getParties();
%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">

li {
	display: inline-block; /* 1. li의 속성을 인라인 블록으로 변경 */
}

ul {
	text-align: center; /* 인라인 속성으로 변한 li들을 텍스트로 인식해 중앙정렬 */
}

.circle {
	 height: 150px;
	 width: 150px;
	 border-radius: 100px;
	 font-size: 16px;
	 text-align: center;
	 line-height: 200px;
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

<%
	if (loginId != null) {
%>

<div>
	<ul>
<%
		for (Party party : parties) {
%>
		<li>
			<a><%=party.getNo() %></a>
			<a><%=party.getFilename() %></a>
			<a><%=party.getName() %></a>
			<a><%=party.getCurCnt() %></a>
		</li>	
<%
		}
%>
	</ul>
</div>
<%
	}
%>

<div>
	<h4>새로운 파티 만들기</h4>

	<ul>	
<%
	for (Category category : categories){
%>
		<li>
			<a><%=category.getName() %></a>
		</li>
<%
	}
%>
	</ul>
</div>
<div>
	<h4>이런 파티는 어때요</h4>
	<ul>
<%
	for (Party party : parties){
%>
		<li>
			<a><%=party.getName() %></a>
			<a><%=party.getDescription() %></a>
			<a><%=party.getCurCnt() %></a>
		</li>
<%
	}
%>		
	</ul>
</div>
</div>
</body>
</html>