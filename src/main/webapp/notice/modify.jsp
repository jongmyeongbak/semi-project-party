<%@page import="java.net.URLEncoder"%>
<%@page import="vo.Board"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
String title = request.getParameter("title");
String content = request.getParameter("content");
if ("".equals(title) || "".equals(content) || title == null || content == null) { // "": normal case, null: abnormal case
	response.sendRedirect("modify-form.jsp?err=empty");
	return;
}

//유저권한이 없으면 list로 리다이렉트
Integer auth = (Integer) session.getAttribute("auth");
if (auth == null || auth > 3) {
	response.sendRedirect("list.jsp");
	return;
}

String loginId = (String) session.getAttribute("loginId");
int no = StringUtils.stringToInt(request.getParameter("no"));

AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
Board board = adminNoticeDao.getNoticeByNo(no);

//해당 글이 없다면 list로 리다이렉트
if (board == null) {
	response.sendRedirect("list.jsp");
	return;
}
//이미 삭제되었다면 detail로 리다이렉트
if ("Y".equals(board.getDeleted())){
	response.sendRedirect("detail.jsp?no="+ no +"&err=del&job=" + URLEncoder.encode("공지수정", "utf-8"));
	return;
}
//다른 사람의 글이라면 detail로 리다이렉트
if (!board.getUser().getId().equals(loginId)){
	response.sendRedirect("detail.jsp?no="+ no +"&err=id&job=" + URLEncoder.encode("공지수정", "utf-8"));
	return;
}

// 글 수정
board.setTitle(title);
board.setContent(content);
adminNoticeDao.updateNotice(board);

response.sendRedirect("detail.jsp?no=" + no);
%>