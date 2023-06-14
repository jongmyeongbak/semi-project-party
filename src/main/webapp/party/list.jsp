<%@page import="util.StringUtils"%>
<%@page import="vo.Party"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.PartyListDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그인 회원아이디 세션 조회
	String loginId = (String) session.getAttribute("loginId");
	String err = request.getParameter("err");
	String job = request.getParameter("job");
	PartyListDao partyListDao = PartyListDao.getInstance();

	List<Category> categories = partyListDao.getCategories();
	List<Party> regParties = partyListDao.getUserRegPartiesByUserId(loginId);
	List<Party> parties = loginId != null ?  partyListDao.getPartiesWithoutUser(loginId) : partyListDao.getAllParties();
%>
<!doctype html>
<html lang="ko">
<head>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/partylist.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="partylist" name="menu"/>
</jsp:include>
<div class="container" >
<%
	if ("req".equals(err)) {
%>
	<div class="alert alert-danger">
		<strong><%=job %></strong> 에 대한 요청은 거부되었습니다.
	</div>
<%
	}
%>
<!-- 로그인 유저가 가입한 파티 조회 -->
<%
	if (loginId != null) {
		if (!regParties.isEmpty()) {
%>
<div>
	<div><h5>나의 파티</h5></div>
		<div class="regparty-container">
<%
			for (Party regParty : regParties) {
%>
					<a href="board/home.jsp?no=<%=regParty.getNo() %>" class="text-black text-decoration-none">
						<div class="regparty-item">
							<img class="regparty-item img" src="<%=request.getContextPath() %>/resources/thumbnail/<%=regParty.getFilename() %>" alt="">
							<div>
								<strong><%=regParty.getName() %></strong>
								<p><%=regParty.getCurCnt() %>명</p>
							</div>
						</div>
					</a>
<%
			}
%>
		</div>
</div>
<%
		}
%>

<!-- 파티생성을 위한 카테고리 조회 -->
<div>
	<h5>새로운 파티 만들기</h5>
		<div class="category-container">

<%
		for (Category category : categories) {
%>
				<a href="form.jsp?cat=<%=category.getNo()%>" class="text-black text-decoration-none">
					<div class="category-item item">
						<strong>
							<span><%=category.getName()%></span>
						</strong>
					</div>
				</a>
<%
		}
	}
%>
		</div>
</div>

<!-- 로그인된 유저를 제외한 생성된 모든 파티 조회 -->
<div class="container">
	<h5>이런 파티는 어때요</h5>
	<div class="swiper">
  		<div class="swiper-wrapper">
   	 <!-- Slides -->
<%  // 파티 리스트의 인덱스
    int index = 0;

	for(Party party : parties) {
      // 페이지 시작점에서 swiper-slide div 생성 시작
      if (index % 10 == 0) {
%>
	        <div class="swiper-slide">
	          <div class="party-container">
<% 
      }
%>
<!-- 파티 정보 출력 -->
		            <div class="party-item">
			          <a href="board/home.jsp?no=<%=party.getNo() %>" class="text-black text-decoration-none ">
			          	<img class="party-item img" src="<%=request.getContextPath() %>/resources/thumbnail/<%=party.getFilename() %>" alt="썸네일">
		    	        <div>
		         	    	<strong><%=party.getName() %></strong>
		            	    <p class='text-truncate'><%=party.getDescription() %></p>
		              	</div>
			          </a>
			          <a href="search.jsp?cat=<%=party.getCategory().getNo() %>" class="btn btn-light"><%=party.getCategory().getName() %> 파티 더보기</a>
		            </div>

<% 
      // 한 페이지의 마지막 아이템이거나 마지막 파티를 출력했을 경우 swiper-slide div 생성 종료
      if ((index + 1) % 10 == 0 || index == parties.size() - 1) {
%>
         	  </div> <!-- party-container 닫힘 -->
            </div> <!-- swiper-slide 닫힘 -->
<% 
      }
      index++;
    } 
%>
        </div> <!-- swiper-wrapper 닫힘 -->	   
	
	<!-- 스와이퍼 버튼 -->
	<div class="swiper-button-prev"></div>
	<div class="swiper-button-next"></div>
	<!-- 스와이퍼 스크롤바 -->
	<div class="swiper-scrollbar"></div>
	</div> <!-- swiper 닫힘 -->
</div> <!-- 로그인된 상태에서의 파티 목록 조회 닫힘 -->
</div>
<script> 
//Swiper 객체 생성
let swiper = new Swiper('.swiper', {
  // 스와이퍼 라이브러리의 기본설정 슬라이드 넘기기 형식(수평), 무한 루프(false)
  direction: 'horizontal',
  loop: false,
  
  // 스와이퍼 라이브러리의 스크롤바 기능 설정
  scrollbar: { 
      el: ".swiper-scrollbar",
      hide: true,
  },
  
  // 스와이퍼 라이브러리의 넘기기 버튼 설정
  navigation: {
	  nextEl: '.swiper-button-next',
	  prevEl: '.swiper-button-prev',
  },
});
</script>
</body>
</html>