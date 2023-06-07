<%@page import="dao.UserAuthDao"%>
<%@page import="java.util.List"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그인처리
	// 파라미터 값 조회하기
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	UserDao userDao = UserDao.getInstance();
	UserAuthDao userAuthDao = UserAuthDao.getInstance();
	
	User user = userDao.getUserById(id);
	
	// 사용자 정보 존재 여부 체크
	if (user == null) {
		response.sendRedirect("login-form.jsp?err=fail");
		return;
	}
	
	// 비밀번호가 일치하는지 체크
	if (!password.equals(user.getPassword())) {
		response.sendRedirect("login-form.jsp?err=fail");
		return;
	}
	
	// 사용자가 탈퇴한 상태인지 체크
	if ("Y".equals(user.getDeleted())) {
		response.sendRedirect("login-form.jsp?err=disabled");
		return;
	}
	
	// 세션에 사용자의 아이디와 권한 정보 저장
	session.setAttribute("loginId", id);
	session.setAttribute("auth", userAuthDao.getAuthById(id));
	
	// 홈화면으로 리디렉트
	response.sendRedirect("home.jsp");
	
%>
