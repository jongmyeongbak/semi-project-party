<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.UserAuthDao"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@page import="util.DateUtils"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	String gender = request.getParameter("gender");
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	String name = request.getParameter("name");
	String nickName = request.getParameter("nickName");
	Date birthdate = DateUtils.stringToDate((request.getParameter("birthdate")));
	String email = request.getParameter("email");
	String tel = request.getParameter("tel");
	
	UserDao userDao = UserDao.getInstance();
	UserAuthDao userAuthDao = UserAuthDao.getInstance();
	
	User user = new User();
	user.setGender(gender);
	user.setId(id);
	user.setPassword(password);
	user.setName(name);
	user.setNickname(nickName);
	user.setBirthdate(birthdate);
	user.setEmail(email);
	user.setTel(tel);
	
	// 아이디 중복 체크
	if (userDao.getUserById(id) != null) {
		response.sendRedirect("form.jsp?err=id");
		return;
	}
	
	// 이메일 중복 체크
	if (userDao.getUserByEmail(email)!= null ) {
		response.sendRedirect("form.jsp?err=email");
		return;
	}
	
	// 아이디가 null이거나 비어있거나 공백문자일 때 (url로 접근 시도시 home.jsp로 리디렉트)
	if (id == null || id.isBlank()) {
		response.sendRedirect("../home.jsp");
		return;
	}
	
	userDao.insertUser(user);
	userAuthDao.insertUserAuth(id, 4);
	
	response.sendRedirect("registered.jsp");
%>