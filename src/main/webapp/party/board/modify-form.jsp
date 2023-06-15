<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 요청 파라미터 조회
	
	
	// 수정할 게시물 번호
	Integer boardNo = StringUtils.stringToInt(request.getParameter("boardNo"));
%>