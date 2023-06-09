<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 요청파라미터값 조회
	String id = request.getParameter("id");

	// 요청파라미터로 전달받은 아이디에 해당하는 회원정보 조회
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(id);
	
	// 회원정보를 yes로 변경
	user.setDeleted("YES");
	
	// 변경된 회원정보 테이블 반영
	userDao.updateUser(user);
	
	// 재요청하는 응답
	response.sendRedirect("user.jsp");
	
%>