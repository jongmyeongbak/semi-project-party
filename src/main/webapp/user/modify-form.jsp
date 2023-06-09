<%@page import="vo.User"%>
<%@page import="dao.UserAuthDao"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String id = request.getParameter("id");
	
	UserDao userDao = UserDao.getInstance();
	UserAuthDao userAuthDao = UserAuthDao.getInstance();
	
	User user = userDao.getUserById(id);
	
	
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
</head>
<body>

<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
			<h1 class="border bg-light fs-4 p-2">나의정보 수정하기</h1>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>나의 정보를 확인하고, 수정하세요</p>
			
			<form class="border bg-light p-3" method="post" action="modify.jsp">
				<input type="hidden" name="no" value="">
				
				<div class="form-group mb-2">
					<label class="form-label">아이디</label>
					<input type="text" class="form-control" name="id" value="" readonly />
				</div>
				<div class="form-group mb-2">
					<label class="form-label">비밀번호</label>
					<input type="text" class="form-control" name="password" value=""/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">이름</label>
					<input type="text" class="form-control" name="name" value="" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">생년월일</label>
					<input type="text" class="form-control" name="birthdate" value="" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">닉네임</label>
					<input type="text" class="form-control" name="nicname" value=""/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">성별</label></br>
					<input type="radio" class="form-check-input" name="gender" value="" checked/>남
					<input type="radio" class="form-check-input" name="gender" value="" checked/>여
				</div>
				<div class="form-group mb-2">
					<label class="form-label">전화번호</label>
					<input type="text" class="form-control" name="tel" value=""/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">이메일</label>
					<input type="text" class="form-control" name="email" value=""/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">최초 수정날짜</label>
					<input type="text" class="form-control" name="email" value="" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">가입일자</label>
					<input type="text" class="form-control" name="email" value="" readonly/>
				</div>
				<div class="text-end">
           				 <a href="registrated.jsp" class="btn btn-primary btn-sm">수정완료</a>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>