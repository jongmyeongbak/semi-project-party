
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%
	String loginId = (String) session.getAttribute("loginId");
	
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(loginId);
%>
<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<%-- <jsp:include page="../nav.jsp">
	<jsp:param name="menu" value="userInfo"/>
</jsp:include> --%>
<div class="container my-3">
   <div class="row mb-3">
      <div class="col-12">
         <h1 class="border bg-light fs-4 p-2">나의 상세 정보</h1>
      </div>
   </div>
   <div class="row mb-3">
      <div class="col-12">
         <p>나의 상세정보를 확인하세요.</p>
         
         <table class="table table-bordered ">
            <colgroup>
               <col width="20%">
               <col width="30%">
               <col width="20%">
               <col width="40%">
            </colgroup>
            <tbody>
               <tr>
                  <th>아이디</th>
                  <td></td>
                  <th>비밀번호</th>
                  <td></td>
               </tr>
               <tr>
                  <th>이름</th>
                  <td></td>
                  <th>생년월일</th>
                  <td></td>
               </tr>
               <tr>
                  <th>닉네임</th>
                  <td><strong class="text-danger"></strong></td>
                  <th>성별</th>
                  <td><span class="text-decoration-line-through"></span></td>
               </tr>
               <tr>
                  <th>전화번호</th>
                  <td></td>
                  <th>이메일</th>
                  <td></td>
               </tr>
               <tr>
                  <th>최초 수정일자</th>
                  <td></td>
                  <th>가입일자</th>
                  <td></td>
               </tr>
               
            </tbody>
         </table>
         <div class="text-end">
            <a href="modify-form.jsp?=" class="btn btn-warning btn-sm">수정하기</a>
         </div>
      </div>
   </div>
      <div class="row mb-3">
      		<div class="col-12">
      	 </div>
  	 </div>
 </div>
</body>
</html>