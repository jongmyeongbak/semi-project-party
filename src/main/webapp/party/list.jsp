<%@page import="util.StringUtils"%>
<%@page import="vo.Party"%>
<%@page import="vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="dao.PartyListDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	// 로그인 회원아이디 세션 조회
	String loginId = (String) session.getAttribute("loginId");

	PartyListDao partyListDao = PartyListDao.getInstance();

	List<Category> categories = partyListDao.getCategories();
	List<Party> regParties = partyListDao.getUserRegPartiesByUserId(loginId);
	
	List<Party> parties = loginId != null ?  partyListDao.getPartiesWithoutUser(loginId) : partyListDao.getAllParties() ;
%>
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">
/* 전체적인 백그라운드 컬러 */
.background-color {
	background-color: rgb(237, 246, 255);
	border-radius: 10px;
}

/* 내가 가입한 파티 컨테이너 css */
.regparty-container {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    background-color: rgb(237, 246, 255);
    padding-top: 15px;
    border-radius: 10px;
}

/* 내가 가입한 파티 아이템 css */
.regparty-item {
	display: flex;
	flex-direction: column; 
	align-items: center;
	justify-content: flex-start;
	height: 230px;
	border-radius: 10px;
	background-color: #ffffff;
	margin-left: 18px;
	margin-right: 18px;
	margin-bottom: 15px;
}

/* 내가 가입한 파티 아이템 이미지 css */
.regparty-item img {
	width: 100%;
	height: 66%;
	justify-content: space-between;
	object-fit: cover;
}

/* 카테고리 컨테이너 */
.category-container {
    display: flex;
    justify-content: space-evenly;
    flex-wrap: wrap;
    padding: 30px;
    background-color: rgb(237, 246, 255);
    border-radius: 10px;
}

/* 원형 아이템 안에 카테고리 이름이 들어가있는 형태, 카테고리에 따라 다른 이미지나 로고를 삽입하려면
	이미지 url컬럼이 필요함 */
.category-item {
    width: 115px;
    height: 115px;
    line-height: 115px;
    text-align: center;
    border-radius: 100px;
    background-color: #CEE9FF;
}

/* 생성된 파티 컨테이너 */
.party-container {
	padding: 2em;
    display: grid;
	grid-template-columns: repeat(2, 1fr);
    justify-content: center;
    background-color: rgb(237, 246, 255);
    border-radius: 10px;
}

/* 생성된 파티 아이템 width는 컨테이너안에서 아이템에 적용되는 비율
   overflow는 요소 밖으로 넘치는 데이터를 숨김 */
.party-item {
	width: 98%;
	float: left;
	overflow: hidden;
	margin: 2px;
	border-radius: 10px;
}

/* 생성된 파티 아이템 이미지 */
.party-item img {
	border-radius: 10px;
	width: 100px;
	height: 100px;
	margin-right: 15px;
}

/* h5태그 css */
h5 {
	padding-top: 10px;
	background-color: #ffffff;
}

/* 가입된 파티 마우스 호버 효과 */
.regparty-item:hover {
    transform: scale(1.02);
}

/* 파티 생성 카테고리 마우스 호버 효과 */
.category-item:hover {
	background-color: #ffffff;
    box-shadow: 0px 10px 10px lightgrey;
}

/* 생성된 파티 마우스 호버 효과 */
.party-item:hover {
	background-color: #ffffff;
    transform: scale(1.02);
}

</style>
<title></title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="partylist" name="파티리스트"/>
</jsp:include>
<div class="container" >
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
					<a href="party-home.jsp?no=<%=regParty.getNo() %>" class="text-black text-decoration-none">
						<div class="regparty-item">
							<img class="regparty-item img" src="IMG_4834.jpg" alt="">
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
				<div class="category-item item">
					<a href="form.jsp?cat=<%=category.getNo()%>" class="text-black text-decoration-none">
						<strong>
							<span><%=category.getName()%></span>
						</strong>
						</a>
				</div>
<%
		}
%>
		</div>
</div>

<!-- 로그인된 유저를 제외한 생성된 모든 파티 조회 -->
<div>
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
			          <a href="home.jsp?no=<%=party.getNo() %>" class="text-black text-decoration-none ">
			          	<img class="party-item img" src="IMG_4834.jpg" alt="">
		    	        <div>
		         	    	<strong><%=party.getName() %></strong>
		            	    <p class='text-truncate'><%=party.getDescription() %></p>
		              	</div>
			          </a>
			          <a href="search.jsp?cat=<%=party.getCategory().getNo() %>" class="btn btn-light"><%=party.getCategory().getName() %> 파티 더보기</a>
		            </div>

<% 
      // 한 페이지의 마지막 아이템이거나 마지막 파티를 출력했을 경우 div 생성 종료
      if ((index + 1) % 10 == 0 || index == parties.size() - 1) {
%>
         	  </div> <!-- party-container -->
            </div> <!-- swiper-slide -->
<% 
      }
      index++;
    } 
%>
        </div> <!-- swiper-wrapper -->
	   
	<!-- If we need pagination -->
	<div class="swiper-pagination"></div>
	
	<!-- If we need navigation buttons -->
	<div class="swiper-button-prev"></div>
	<div class="swiper-button-next"></div>
	
	<!-- If we need scrollbar -->
	<div class="swiper-scrollbar"></div>
	</div> <!-- swiper -->
</div> <!-- 로그인된 상태에서의 파티 목록 조회 닫힘 -->
<%
	} else {
%>
<div>
	<h5>이런 파티는 어때요</h5>
	<div class="swiper">
  		<div class="swiper-wrapper">
   	 <!-- Slides -->
<%  // 10개의 아이템 단위로 페이지를 구분하기 위한 변수
    int pageCounter = 0;
    
    // 전체 파티 리스트의 인덱스
    int index = 0;

	for(Party party : parties) {
      // 페이지 시작점에서 swiper-slide div 시작
      if (index % 10 == 0) {
%>
	        <div class="swiper-slide">
	          <div class="party-container">
<% 
      }
%>
		          <!-- 파티 정보 출력 -->
		            <div class="party-item ">
				    	<a href="home.jsp?no=<%=party.getNo() %>" class="text-black text-decoration-none">
			              <img class="party-item img" src="IMG_4834.jpg" alt="">
			              <div>
			                <strong><%=party.getName() %></strong>
			                <p class="text-truncate"><%=party.getDescription() %></p>
			              </div>
			            </a>
		                <a href="search.jsp?cat=<%=party.getCategory().getNo() %>"class="btn btn-light"><%=party.getCategory().getName() %> 파티 더보기</a>
		            </div>
		         

<% 
      // 한 페이지의 마지막 아이템이거나 마지막 파티를 출력했을 경우 div 종료
      if ((index + 1) % 10 == 0 || index == parties.size() - 1) {
%>
         	  </div> <!-- party-container -->
            </div> <!-- swiper-slide -->
<% 
      }

      index++;
    } 
%>
        </div> <!-- swiper-wrapper -->
	
	<!-- If we need navigation buttons -->
	<div class="swiper-button-prev"></div>
	<div class="swiper-button-next"></div>
	
	<div class="swiper-scrollbar"></div>
	</div> <!-- swiper -->
<%
	}
%>
</div> <!-- 로그아웃 상태 생성된 모든 파티 목록 조회 닫힘-->

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