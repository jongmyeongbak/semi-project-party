<%@page import="vo.GuestBook"%>
<%@page import="util.StringUtils"%>
<%@page import="dao.GuestBookDao"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%
	 int gbNo = Integer.parseInt(request.getParameter("gbNo"));
	 int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));
	 String loginId = (String)session.getAttribute("loginId"); 
	 
	 GuestBookDao guestbookdao = GuestBookDao.getInstance();
	 GuestBook guestbook = guestbookdao.getGuestBookByGbNo(gbNo);
	 if(!loginId.equals(guestbook.getUser().getId())){
		 response.sendRedirect("gbook.jsp?no="+partyNo +"&err=id");
		 return;
	 }
	 
	 //방명록삭제
	guestbookdao.deleteGuestBookByGbNo(gbNo);
	 
	response.sendRedirect("gbook.jsp?no="+partyNo);
%>		 