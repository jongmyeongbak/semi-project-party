<%@page import="vo.PartyAccess"%>
<%@page import="dao.PartyAccessDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="dao.GuestBookDao"%>
<%@page import="vo.User"%>
<%@page import="dao.UserDao"%>
<%@page import="vo.GuestBook"%>
<%@page import="util.StringUtils"%>
<%@page import="vo.Party"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	//insert
	int partyNo = StringUtils.stringToInt(request.getParameter("partyNo"));
	String content = request.getParameter("content");
	
	String loginId = (String) session.getAttribute("loginId");
	
	if(loginId == null || "".equals(loginId)){
		response.sendRedirect("../login-form.jsp?err=req&job="+URLEncoder.encode("방명록","utf-8"));
		return;
	}	
	if(content == null || "".equals(content)){
		 out.println("<script>alert('내용을 입력해주세요.');</script>");
		 out.println("<script>history.back();</script>");
		return;
	}
	if (content.getBytes("UTF-8").length > 500) {
	    out.println("<script>alert('글자수를 초과했습니다(최대500자)');</script>");
	    out.println("<script>history.back();</script>");
	    return;
	}
	
  	GuestBookDao guestbookdao = GuestBookDao.getInstance();
	
  	GuestBook guestBook = new GuestBook();
  	guestBook.setUser(new User(loginId));
  	guestBook.setParty(new Party(partyNo));
  	guestBook.setContent(content);
  
  	guestbookdao.insertGuestBook(guestBook);
  	
  	response.sendRedirect("gbook.jsp?no="+partyNo);
%>
  