<%@page import="vo.User"%>
<%@page import="dao.UserAuthDao"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String loginId = (String) session.getAttribute("loginId");
	String id = request.getParameter("id");
	String err = request.getParameter("err");

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
<jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="user-info"/>
</jsp:include> 
<div class="container my-3">
	<div class="row mb-3">
		<div class="col-12">
			<h1 class="border bg-light fs-4 p-2">나의정보 수정하기</h1>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-12">
			<p>나의 정보를 확인하고, 수정하세요</p>
<%
	if ("empty".equals(err)) {
%>
		<div class="alert alert-danger">
			<strong>수정 실패</strong> 빈칸을 채워주세요.
		</div>
<%
		}
%>
			
			<form class="border bg-light p-3" method="post" action="modify.jsp">
				
				<div class="form-group mb-2">
					<label class="form-label">아이디</label>
					<input type="text" class="form-control" name="id" value="<%=user.getId() %>" readonly />
				</div>
				<div class="form-group mb-2">
					<label class="form-label">비밀번호</label>
					<input type="password" class="form-control" name="password" required/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">이름</label>
					<input type="text" class="form-control" name="name" value="<%=user.getName() %>" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">생년월일</label>
					<input type="text" class="form-control" name="birthdate" value="<%=user.getBirthdate() %>" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">닉네임</label>
					<input type="text" class="form-control" name="nickname" value="<%=user.getNickname()%>" required />
				</div>
				<div class="form-group mb-2">
					<label class="form-label">성별</label><br/>
					<input type="radio" class="form-check-input" name="gender" value="M" checked/>남
					<input type="radio" class="form-check-input" name="gender" value="F" checked/>여
				</div>
				<div class="form-group mb-2">
					<label class="form-label">전화번호</label>
					<input type="text" class="form-control" name="tel" value="<%=user.getTel()%>" required/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">이메일</label>
					<input type="text" class="form-control" name="email" value="<%=user.getEmail()%>" required/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">최종 수정일자</label>
					<input type="text" class="form-control" name="updatedate" value="<%=user.getUpdateDate() %>" readonly/>
				</div>
				<div class="form-group mb-2">
					<label class="form-label">가입일자</label>
					<input type="text" class="form-control" name="createdate" value="<%=user.getCreateDate() %>" readonly/>
				</div>
				<div class="text-end">
					
					<button type="submit" class="btn btn-primary btn-sm">수정</button>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>