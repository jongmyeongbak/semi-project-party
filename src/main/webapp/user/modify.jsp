<%@page import="java.util.Date"%>
<%@page import="util.DateUtils"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 요청 파라미터값 조회
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	String name = request.getParameter("name");
	String nickname = request.getParameter("password");
	String gender = request.getParameter("gender");
	Date birthdate = DateUtils.stringToDate(request.getParameter("birthdate"));
	String email = request.getParameter("email");
	String tel = request.getParameter("tel");
	
	// User객체를 생성해서 요청파라미터로 제출받은 고객정보저장
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(id);
	
	// 요청파라미터로 전달받은 수정된 고객정보를 user객체에 저장하기
	user.setId(id);
	user.setPassword(password);
	user.setName(name);
	user.setNickname(nickname);
	user.setGender(gender);
	user.setBirthdate(birthdate);
	user.setEmail(email);
	user.setTel(tel);
	
	// 이메일 중복체크
	if (userDao.getUserByEmail(email) != null) {
		response.sendRedirect("user-modify.jsp?err=email");
		return;
	}
	// 닉네임 중복체크
	if (userDao.getUserByNickname(nickname) != null) {
		response.sendRedirect("user-modify.jsp?err=nickname");
		return;
	}
	
	
	
	// 수정된 정보가 포함된 User객체를 데이터베이스에 반영시키기
	userDao.updateUser(user);
	
	// 재요청URL응답
	response.sendRedirect("registrated.jsp");
	
	
	
%>