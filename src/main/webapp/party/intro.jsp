<%@page import="dao.PartyAccessDao"%>
<%@page import="vo.PartyAccess"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="dao.PartyDao"%>
<%@page import="vo.Party"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
int no = StringUtils.stringToInt(request.getParameter("no"));
Party party = PartyDao.getInstance().getPartyByNo(no);
if (party == null) {
	return;
}
String partyFileUrl = (party.getFilename() == null)
		? request.getContextPath() + "/resources/thumbnail/sample.jpg"
		: "/images/thumbnail/" + party.getFilename();
String loginId = (String) session.getAttribute("loginId");
%>
<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script>
	function toggleTextTruncate(e) {
		var content = document.getElementById("leadContent");

		if (content.classList.contains("text-truncate")) {
			content.classList.remove("text-truncate");
			e.target.textContent = "...접기";
		} else {
			content.classList.add("text-truncate");
			e.target.textContent = "...더보기";
		}
	}
</script>
</head>
<body>
<div class="container p-4 p-md-5 mb-4 rounded bg-primary bg-opacity-10">
    <div class="row">
    	<div class="col-md-4">
		    <img src=<%=partyFileUrl %> alt="intro image" style="width: 100%; height: 100%; object-fit: contain; object-position: top;">
    	</div>
    	<div class="col-md-8 mt-3 ps-3">
			<h2 class="fs-2 fw-bolder"><%=party.getName() %>
			<%
			if (loginId == null) {
				String targetPath = URLEncoder.encode("party/join.jsp?no=", "utf-8");
			%>
				<a href="../login-form.jsp?redirect=<%= targetPath %><%=no %>" class="btn btn-success btn-lg ms-3 mb-2">가입</a>
			<%
			} else {
				Integer partyAuth = PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(no, loginId);
				if (partyAuth == null) {
			%>
				<a href="join.jsp?no=<%=no %>" class="btn btn-success btn-lg ms-3 mb-2">가입</a>
			<%
				} else if (partyAuth == 6) {
			%>
				<a href="modify-form.jsp?no=<%=no %>" class="btn btn-success ms-3 mb-2">파티설정</a>
			<%
				}
			}
			%>
			</h2>
			<p class="lead my-3 text-truncate" id="leadContent" style='white-space: break-spaces;'><%=party.getDescription() %></p>
			<span class="mb-0" onclick="toggleTextTruncate(event);">...더보기</span>
    	</div>
    </div>
</div>
</body>
</html>