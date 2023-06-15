<%@page import="com.google.gson.Gson"%>
<%@page import="vo.Party"%>
<%@page import="dao.PartyListDao"%>
<%@page import="java.util.List"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true"%>
<%
	int pageNo = StringUtils.stringToInt(request.getParameter("pageNo"));
	int catNo = StringUtils.stringToInt(request.getParameter("catNo"));
	int beginPage = pageNo*5 - 4;
	int endPage = pageNo*5;
	
	PartyListDao partyListDao = PartyListDao.getInstance();
	List<Party> partyList;
	if (catNo == 0){
		partyList = partyListDao.getAllPartiesWithCat(beginPage, endPage);
	} else {
		partyList = partyListDao.getPartiesWithCatByCatNo(catNo, beginPage, endPage);	
	}
	
	Gson gson = new Gson();
	String text = gson.toJson(partyList);
	
	out.write(text);
%>
