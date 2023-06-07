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
	
 -->
 <%
 	String loginId = (String) session.getAttribute("loginId");
 	String menu = request.getParameter("menu");
 	
 %>
<style>
	nav {
		height: 70px;
		font-size: 18px;
		background-color: rgb(252, 185, 196);
	}
	.form {
    	position: relative;
   	}
	.search {
	    width: 33px;
	    height: 33px;
	    background-color: #fff;
	    border: 1px solid black;
	    display: inline-block;
	    text-align: center;
	    position: absolute;
	    top: 0px;
	    right: 0px;
	    cursor: pointer;
	}
</style>
<script src="https://kit.fontawesome.com/46a6014d50.js" crossorigin="anonymous"></script>
<div class="container">
	<div class="row align-items-center">
		<div class="col">
	        <p class="fs-1 text-center"><span id="home" class="align-middle" style="cursor: pointer;">파티(로고 이미지)</span></p>
		</div>
	</div>
</div>
<nav class="navbar navbar-expand-sm mb-3">
	<div class="container">
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
		        <li class="nav-item">
		        	<div class="form">
				    	<form method="get" action="/party/list.jsp" name="searchParty">
				        	<input type="text" placeholder="파티검색" name="value">
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
				<span class="navbar-text align-middle bolder"><strong class="text-black"><%=nickname %>님 환영합니다.</strong></span>
	           	<li class="nav-item dropdown">
	           		<a class="nav-link dropdown-toggle <%= "userInfo".equals(menu) ? "active fw-bold" : "" %>" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
	           		MY
	           		</a> <!-- 아이콘이나 박스에 담으면 보기 좋을 듯  -->
	           		<ul class="dropdown-menu">
	           			<li><a href="/user/user-info.jsp" class="dropdown-item">내정보보기</a></li>
	           			<li><a href="/user/user-partylist.jsp" class="dropdown-item">내파티리스트</a></li>
	           		</ul>
	           	</li>
	            <li class="nav-item">
	                <a href="/logout.jsp" class="nav-link">로그아웃</a> <!-- 아이콘이나 박스에 담으면 보기 좋을 듯  -->
	            </li>
	        </ul>
<%
	}
%>

    	</div>
	</div>
</nav>
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