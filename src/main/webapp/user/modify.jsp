<%@page import="util.StringUtils"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Date"%>
<%@page import="util.DateUtils"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 요청 파라미터값 조회
	String loginId = (String) session.getAttribute("loginId");
	String password = request.getParameter("password");
	String nickname = request.getParameter("nickname");
	String email = request.getParameter("email");
	String tel = request.getParameter("tel");

	// loginId에 해당하는 고객정보 조회하여 user객체에 저장
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(loginId);

	// 중복된 닉네임 여부 체크
	User savedUserNickname = userDao.getUserByNickname(loginId, nickname);
	/*
		select
		from
		where user_id != ?
		and user_nickname = ?
	*/
	
	if (savedUserNickname != null) {
		response.sendRedirect("modify-form.jsp?err=nickname");
		return;
	}
	
	// 중복된 이메일 여부 체크
	User savedUserEmail = userDao.getUserByIdAndEmail(loginId, email);
	/*
	select
	from
	where user_id != ?
	and user_email = ?
	*/
	if (savedUserEmail != null) {
		response.sendRedirect("modify-form.jsp?err=email");
		return;
	}
	
	if (password.isBlank()) {
		response.sendRedirect("modify-form.jsp?err=blank");
		return;
	} else if (!password.equals(user.getPassword())) {
		response.sendRedirect("modify-form.jsp?err=pwd");
		return;
	}
	
	// 요청파라미터로 전달받은 수정된 고객정보를 user객체에 저장하기
	user.setPassword(password);
	user.setNickname(nickname);
	user.setEmail(email);
	user.setTel(tel);

	
	// 수정된 정보가 포함된 User객체를 데이터베이스에 반영시키기
	userDao.updateUser(user);
	
	// 재요청URL응답
	response.sendRedirect("modified.jsp?id=" + loginId);
%>