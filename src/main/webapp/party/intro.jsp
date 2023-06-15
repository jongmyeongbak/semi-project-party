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
<script>
	function redirectToLogin() {
		let originalUrl = window.location.href;
		window.location.href = "../login-form.jsp?redirect=" + encodeURIComponent(originalUrl);
	}
	
	function joinParty(no, e) {
		let xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
				let data = xhr.responseText;
				switch (data) {
					case 'login':
						alert("로그인이 필요합니다.");
						redirectToLogin();
						break;
					case 'join':
						alert("가입을 환영합니다.");
						e.target.remove();
						break;
					case 'rejoin':
						alert("재가입을 환영합니다.");
						e.target.remove();
						break;
					case 'ban':
						alert("이 파티에 가입할 수 없습니다.");
						location.reload(true);
						break;
					case 'already':
						alert("이미 가입되어 있습니다.");
						location.reload(true);
						break;
					default:
						alert(data);
						break;
				}
			}
		}
		xhr.open("Get", "join.jsp?no=" + no, false);
		xhr.send(null);
	}
	
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
<div class="container p-4 p-md-5 mb-4 rounded bg-primary bg-opacity-10">
    <div class="row">
    	<div class="col-md-4">
		    <img src=<%=partyFileUrl %> alt="intro image" style="width: 100%; height: 100%; object-fit: contain; object-position: top;">
    	</div>
    	<div class="col-md-8 mt-3 ps-3">
			<h2 class="fs-2 fw-bolder"><%=party.getName() %>
			<%
			if (loginId == null) {
			%>
				<button class="btn btn-success btn-lg ms-3 mb-2" onclick="confirm('로그인이 필요합니다.') && redirectToLogin()">가입</button>
			<%
			} else {
				Integer partyAuth = PartyAccessDao.getInstance().getAuthNoByPartyNoAndUserId(no, loginId);
				if (partyAuth == null || partyAuth == 8) {
			%>
				<button type="button" class="btn btn-success btn-lg ms-3 mb-2" onclick="confirm('가입하시겠습니까?') && joinParty(<%=no %>, event)">가입</button>
			<%
				} else if (partyAuth == 6) {
			%>
				<a href="modify-form.jsp?no=<%=no %>" class="btn btn-success ms-3 mb-2" onclick="return confirm('이동하시겠습니까?')">파티설정</a>
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