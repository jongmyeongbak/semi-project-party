<%@page import="java.net.URLEncoder"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.User"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	int no = StringUtils.stringToInt(request.getParameter("no"));
	UserDao userDao = UserDao.getInstance();
	List<User> userList = userDao.getUserByPartyNo(no);
	if (userList == null) {
		response.sendRedirect("../list.jsp?err=req&job=" + URLEncoder.encode("파티 멤버 보기", "UTF-8"));
		return;
	}
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<style type="text/css">
        .bg {
            background-color: #fff;
            padding: 10px 0;
        }
        .user-item {
            width: 46%;
            height: 70px;
            border: 2px solid #999;
            border-radius: 15px;
            margin: 10px 2%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-box {
            background-color: rgb(237, 246, 255);
        }
        .btn {
            border: none;
        }
        .user-item:first-of-type span::after {
            content: "리더";
            font-size: 12px;
            font-weight: bold;
            margin-left: 5px;
            padding: 2px;
            color: #333;
            border: 1px solid rgb(237, 246, 255);
            background-color: rgb(216, 235, 255);
            border-radius: 6px;
        }  
	</style>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="member" name="pmenu"/>
</jsp:include>
<div class="container">
	<div class="text-center">
	    <h3>멤버 목록을 확인하세요</h3>
	</div>
    <div class="user-box pt-3 px-5 my-5">
    	<div class="row pb-3 fs-5">총 멤버 수 : <%=userList.size() %>명</div>
        <div class="bg row">
<%
	for (User user : userList) {
%>
            <div class="user-item">
                <span><%=user.getNickname() %></span>
                <a href="" class="btn" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fa-solid fa-ellipsis-vertical"></i></a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#">프로필</a></li>
                    <li><a class="dropdown-item" href="#">1:1 채팅</a></li>
                    <li><a class="dropdown-item" href="#">메세지 보내기</a></li>
                </ul>
            </div>
<%
	}
%>
        </div>
    </div>
</div>
</body>
</html>