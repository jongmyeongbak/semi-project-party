<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그아웃 처리
	session.invalidate();
	
	// 홈화면으로 리다이렉트
	response.sendRedirect("home.jsp");
%>