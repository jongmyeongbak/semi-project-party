<%@page import="vo.Category"%>
<%@page import="dao.PartyListDao"%>
<%@page import="vo.Party"%>
<%@page import="vo.Board"%>
<%@page import="java.util.List"%>
<%@page import="dao.AdminNoticeDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
//samllnotice 로직
final int first = 1;
final int last = 5;
AdminNoticeDao adminNoticeDao = AdminNoticeDao.getInstance();
List<Board> adminNoticeList = adminNoticeDao.getNotices("N", first, last);
//로그인 로직
String loginId = (String) session.getAttribute("loginId");
//smallparty 로직
PartyListDao partyListDao = PartyListDao.getInstance();
List<Category> categoryList = partyListDao.getCategories();
//로그인 하면 보여지는 내 파티가입리스트에 사용됨
List<Party> smallPartyList = partyListDao.getUserRegPartiesByUserId(loginId);
//모든 파티에 대한 정보를 가져오는데 사용됨
List<Party> partyList = partyListDao.getPartiesWithoutUser(loginId);
%>
<!doctype html>
<html lang="ko">
<head>
<title>파티홈입니다.</title>
<link rel="stylesheet" href="css/home.css"/>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<style type="text/css">
   td a, td a:active, td a:visited {
      color: #333;
      text-decoration: none;
      transition: color 0.1s;
   }
   td a:hover {
      color: rgb(58, 156, 255);
      text-decoration: none;
   }
   .border {
      background-color: rgb(237, 246, 255);
   }
   .btn {
      border: 1px solid #6DA1FF;
      color: #6DA1FF;
      background-color: #fff;
      border-radius: 10px;
   }
   .btn:hover {
      color: #ffffff;
       border-color: #6DA1FF;
         background-color: #6DA1FF;
   }
</style>
</head>
<body>
<jsp:include page="nav.jsp">
   <jsp:param name="menu" value="home"/>
</jsp:include>

<div class="container">
<h1 class="fs-3">파티(로고)</h1> <!-- fs-3  p-->
   <div class="container mt-3">
      <div class="row"> 
         <div class="col-6">
               <div class="row mb-3">
                  <div class="col-10">
                     <div class="border fs-5 p-2 ">공지사항</div>
                     </div>
                  </div>
                  <div class="row mb-3">
                     <div class="col-10">
                        <table class="table table-sm">
                           <colgroup>
                              <col width="15%">
                              <col width="45%">
                              <col width="20%">
                              <col width="20%">
                           </colgroup>
                           <thead>
                              <tr>
                                 <th>글쓴이</th>
                                 <th>제목</th>
                                 <th>등록일</th>
                                 <th>조회수</th>
                              </tr>
                           </thead>
                           <tbody>
<%
   for(Board board: adminNoticeList){
%>
                              <tr>
                                 <td><%=board.getUser().getNickname() %></td>
                                 <td><a href="notice/detail.jsp?no=<%=board.getNo() %>"><%=board.getTitle() %></a></td>
                                 <td><%=board.getCreateDate() %></td>
                                 <td><%=board.getReadCnt() %></td>
                              </tr>
<% 
   }
%>      
                           </tbody>
                        </table>
                     </div>
                  </div>
                  <div class="row mb-2">
                     <div class="col-10">
                        <p class="border p-3 "></p>
                        <div class="text-end">
                             <a href="notice/list.jsp" class="btn btn-sm ">더보기</a>
                        </div>
                     </div>
                  </div>
               
            </div>   <!-- col1-6 닫김 -->   
      
<!-- 카테고리, 이름, 현재인원, 설명  로그인한사람들한테 보이는 파티가입 리스트-->
            <div class="col-6 justify-content-center">
               
                  <div class="row mb-3">
                     <div class="col-14">
                        <div class="border fs-5 p-2 ">파티 가입리스트</div>
                     </div>
                  </div>
                  <div class="row mb-3">
      <div class="col-12">
         <table class="table table-sm">
            <colgroup>
               <col width="40%">
               <col width="30%">
               <col width="30%">
            </colgroup>
            <thead>
               <tr>
                  <th>파티이름</th>
                  <th>현재인원</th>
                  <th>파티설명</th>
               </tr>
            </thead>
            <tbody>
<%
if (loginId != null && !smallPartyList.isEmpty()) {
   int partyCount = 0;
      for(Party party: smallPartyList){
      if (partyCount >= 5) {
            break;
        }
%>
            <tr>
                  <td><a href="party/board/home.jsp?no=<%=party.getNo()%>"><%= party.getName() %></a></td>
                  <td><%=party.getQuota()  %>/<%=party.getCurCnt()%>(명)</td>
                  <td class ="ellipsis"><%= party.getDescription() == null ? "없음" : party.getDescription() %></td>      
            </tr>
<%
   partyCount++; 
   }
} else {
%>
              <tr><td colspan="3">당신의 파티를 추가해보세요.</td></tr>
<%
}
%>
      </tbody>
   </table>
      </div>
         <div class="col-14">
            <p class="border p-3 "></p>
         <div class="text-end">
         <%   if (loginId == null) { %>
              <a href="" class="btn btn-primary btn-sm" onclick="alert('로그인 해주세요.'); return false;">더보기</a>
         <%}else { %>
            <a href="party/list.jsp" class="btn btn-sm" >더보기</a>
         <%}%>         
         </div>
      
      </div>
         </div>

   </div> <!-- col-6 닫김 -->
   
</div>   <!-- row 닫김 -->
</div>   <!-- content 닫김 -->   
</div>

<div class="content">
   
<!-- 최근 순으로 파티를 추천하는 파트 -->
<div class="box-container">
<%
   int partyCount = 0;
   for(Party party: partyList){ 
      if (partyCount >= 5) {
            break;
        }
%>
  <div class="box">
    <div class="image" onclick="window.location.href='party/board/home.jsp?no=<%=party.getNo()%>';">
        <img src="<%=request.getContextPath() %>/images/thumbnail/<%= party.getFilename() %>" alt=" ">
    </div>
    <div class="separator"></div>
    <div class="text" onclick="window.location.href='party/board/home.jsp?no=<%=party.getNo()%>';">
      <ul>
        <li ><%=party.getName()%></li>
        <li>파티인원 : <%=party.getCurCnt()%>명</li>
      </ul>
    </div>
  </div>
      
 <%   
 	partyCount++;
 	} 
 %>
  
</div> <!-- 박스 컨테이너 닫김 -->
</div> <!--  background 닫김 -->
</div><!-- content 닫김 -->

</body>
</html>