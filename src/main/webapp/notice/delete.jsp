<%@page import="vo.Board"%>
<%@page import="dao.AdminNoticeDao"%>
<%@page import="util.StringUtils"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
// 유저권한이 없으면 list로 리다이렉트
Integer auth = (Integer) session.getAttribute("auth");
if (auth == null || auth > 3) {
	response.sendRedirect("list.jsp");
	return;
}

String loginId = (String) session.getAttribute("loginId");
int no = StringUtils.stringToInt(request.getParameter("no"));

AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
Board board = adminNoticeDao.getNoticeByNo(no, "N");

// 해당 글이 없다면 list로 리다이렉트
if (board == null) {
	response.sendRedirect("list.jsp");
	return;
}

// 다른 사람의 글이라면 detail로 리다이렉트
if (!loginId.equals(board.getUser().getId())) {
	response.sendRedirect("detail.jsp?no=" + no + "err=id&job=" + URLEncoder.encode("글삭제", "utf-8"));
	return;
}

// 글 삭제
board.setDeleted("Y");
adminNoticeDao.updateNotice(board);

response.sendRedirect("list.jsp");
%>