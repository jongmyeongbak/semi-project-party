<%@page import="util.StringUtils"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!-- 
	홈 : home
	공지사항 : notice
	회원가입 : register
	로그인 : login
	내정보보기 : userInfo
	파티리스트 : partylist
	
	// 파티 
	게시판 : home
	방명록 : gbook
	앨범 : album
	투표 : vote
	일정 : calendar
	멤버 : member	
	
 -->
 <%
 	String loginId = (String) session.getAttribute("loginId");
 	String menu = request.getParameter("menu");
 	String pmenu = request.getParameter("pmenu");
 	
 %>
<style>
	nav {
		height: 90px;
		font-size: 18px;
		background-color: rgb(237, 246, 255);
	}
	.blank {
		height: 90px;
	}
	.form {
    	position: relative;
   	}
	input {
		border-radius: 20px;
		border: 1px solid #333;
	}
	.search {
	    display: inline-block;
	    text-align: center;
	    position: absolute;
	    top: 1px;
	    right: 10px;
	    cursor: pointer;
	}
	nav:nth-of-type(2) {
		background-color: rgb(194, 225, 255);
		height: 50px;
        margin-top: 90px;
        z-index: 0;
	}
	.nav2 > li {
	    margin-left: 30px;
	}
	.nav2 > li:first-of-type {
	    margin-left: 0px;
	}
	.blank-1 {
		height: 50px;
	}
</style>
<script src="https://kit.fontawesome.com/46a6014d50.js" crossorigin="anonymous"></script>
<nav class="navbar fixed-top navbar-expand-sm <%=pmenu == null ? "mb-3" : "" %>">
	<div class="container fixed">
	    <div class="container">
	        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
	            <li class="nav-item">
	                <a href="/home.jsp" class="nav-link <%= "home".equals(menu) ? "active fw-bold" : "" %>"><i class="fa-solid fa-house"></i></a>
	            </li>
	            <li class="nav-item">
	                <a href="/notice/list.jsp" class="nav-link <%= "notice".equals(menu) ? "active fw-bold" : "" %>">공지사항</a>
	            </li>
	            <li class="nav-item">
	                <a href="/party/list.jsp" class="nav-link <%= "partylist".equals(menu) ? "active fw-bold" : "" %>">파티 리스트</a>
	            </li>
	        </ul>
		</div>
		<div class="container">
	        <ul class="navbar-nav me-auto justify-content-center">
	        	<h1 class="fs-1 text-center"><span id="home" class="align-middle" style="cursor: pointer;">P</span></h1>
                <li class="nav-item ms-2">
                    <div class="form mt-3">
				    	<form method="get" action="/party/list.jsp" name="searchParty">
				        	<input type="text" placeholder="  파티검색" name="value">
				        	<div class="search" id="search">
					    		<i class="fa-solid fa-magnifying-glass"></i>
				        	</div>
			   			</form>
		        	</div>
	       	 	</li>
	        </ul>
		</div>
		<div class="container">
<%
	if (loginId == null) {
%>
	        <ul class="navbar-nav justify-content-end">
	            <li class="nav-item">
	                <a href="/login-form.jsp" class="nav-link <%= "login".equals(menu) ? "active fw-bold" : "" %>">로그인</a>
	            </li>
	            <li class="nav-item">
	                <a href="/user/form.jsp" class="nav-link <%= "register".equals(menu) ? "active fw-bold" : "" %>">회원가입</a>
	            </li>
	        </ul>
<%
	} else {
	 	UserDao userDao = UserDao.getInstance();
	 	User user = userDao.getUserById(loginId);
	 	String nickname = user.getNickname();
%>
	        <ul class="navbar-nav justify-content-end">
	        	<li class="nav-item ms-2">
					<a href="#" class="nav-link"><i class="fa-solid fa-bell"></i></a>
	            </li>
				<li class="nav-item ms-2">
					<a href="#" class="nav-link"><i class="fa-solid fa-message"></i></a>
				</li>
	           	<li class="nav-item dropdown">
	           		<a class="nav-link dropdown-toggle <%= "userInfo".equals(menu) ? "active fw-bold" : "" %>" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
	           		MY
	           		</a>
	           		<ul class="dropdown-menu dropdown-menu-end">
						<li><span class="align-middle bolder ms-3"><strong class="text-black"><%=nickname %> 님</strong></span></li>
	           			<li><hr class="dropdown-divider"></li>
	           			<li><a href="/user/detail.jsp" class="dropdown-item">내정보보기</a></li>
	           			<li><a href="/user/user-partylist.jsp" class="dropdown-item">내파티리스트</a></li>
						<li><hr class="dropdown-divider"></li>
                        <li><a href="/logout.jsp" class="dropdown-item">로그아웃</a></li>
	           		</ul>
	           	</li>
	        </ul>
<%
	}
%>
    	</div>
	</div>
</nav>
<div class="blank mb-3">
</div>
<% 
	if (pmenu != null) {
		int no = StringUtils.stringToInt(request.getParameter("no"));
%>
<nav class="navbar fixed-top navbar-expand-sm">
    <div class="container justify-content-center">
        <ul class="navbar-nav nav2">
            <li class="nav-item">
                <a href="/party/home.jsp?no=<%=no %>" class="nav-link <%= "home".equals(pmenu) ? "active fw-bold" : "" %>">게시판</a>
            </li>
            <li class="nav-item">
                <a href="/party/gbook.jsp" class="nav-link <%= "gbook".equals(pmenu) ? "active fw-bold" : "" %>">방명록</a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link <%= "album".equals(pmenu) ? "active fw-bold" : "" %>">앨범</a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link <%= "vote".equals(pmenu) ? "active fw-bold" : "" %>">투표</a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link <%= "calandar".equals(pmenu) ? "active fw-bold" : "" %>">일정</a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link <%= "member".equals(pmenu) ? "active fw-bold" : "" %>">멤버</a>
            </li>
        </ul>
    </div>
</nav>
<div class="blank-1 mb-3">
</div>
<%
	}
%>
<script>
    let home = document.querySelector("#home");
    home.addEventListener("click", () => {
        location.assign("home.jsp");
    })
    
   	let search = document.querySelector("#search");
    search.addEventListener("click", ()=>{
        const form = document.forms.searchParty;
        form.submit();
    })
</script>