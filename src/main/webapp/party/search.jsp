<%@page import="vo.Party"%>
<%@page import="java.util.List"%>
<%@page import="dao.PartyListDao"%>
<%@page import="util.StringUtils"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	int cat = StringUtils.stringToInt(request.getParameter("cat"));
	String value;
	if (request.getParameter("value") == null) {
		value = " ";
	} else {
		value = request.getParameter("value");
	}
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/partysearch.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<jsp:include page="../nav.jsp">
	<jsp:param value="partyList" name="menu"/>
</jsp:include>
<div class="container">
	<div class="category-list">
		<div class="cat-button">
		    <button type="button" id="cat-0" class="<%=cat == 0 ? "active" : ""%>" onclick="selectCategory(0)">전체</button>
		    <button type="button" id="cat-10" class="<%=cat == 10 ? "active" : ""%>" onclick="selectCategory(10)">취미/동호회</button>
		    <button type="button" id="cat-20" class="<%=cat == 20 ? "active" : ""%>" onclick="selectCategory(20)">가족</button>
		    <button type="button" id="cat-30" class="<%=cat == 30 ? "active" : ""%>" onclick="selectCategory(30)">스터디</button>
		    <button type="button" id="cat-40" class="<%=cat == 40 ? "active" : ""%>" onclick="selectCategory(40)">학교/동아리</button>
		    <button type="button" id="cat-50" class="<%=cat == 50 ? "active" : ""%>" onclick="selectCategory(50)">운동</button>
		    <button type="button" id="cat-60" class="<%=cat == 60 ? "active" : ""%>" onclick="selectCategory(60)">지역</button>
		    <button type="button" id="cat-90" class="<%=cat == 90 ? "active" : ""%>" onclick="selectCategory(90)">자유주제</button>
		</div>
	</div>
	<div class="party-list" id="party-list">
	</div>
	<div id="target"></div>
</div>
<script type="text/javascript">

	let currentPage = 1;
	let catNo = <%=cat %>;
	let isChecked = true;
	let value = "<%=value %>";
	
	function selectCategory(cat) {
		let btns = document.querySelectorAll(".cat-button button");
		
		btns.forEach(btn => {
		    btn.classList.remove("active");
		});
		document.getElementById("cat-" + cat).classList.add("active");
		document.querySelector("#party-list").innerHTML = "";
		
		catNo = cat;
		value = " ";
		
		isChecked = true;
		currentPage = 1;
		getParties();
	}
	
	let target = document.querySelector("#target");
	
	const option = {
		root: null,
		rootMargin: '0px 0px 0px 0px',
		threshole: 0.5
	}
	
	const onIntersect = (entries, observer) => {
		entries.forEach(entry => {
			if (entry.isIntersecting){
				
				isChecked = true;
				getParties();
			}
		})
	}
	const observer = new IntersectionObserver(onIntersect, option);
	observer.observe(target);

	// ajax 쓰기
	function getParties(pageNo){
		console.log(isChecked);
		if (isChecked) {
			let xhr = new XMLHttpRequest();
			xhr.addEventListener("readystatechange", ()=>{
				if (xhr.readyState == 4) {
					let data = xhr.responseText;
					let arr = JSON.parse(data);
					console.log(arr);
					if (arr.length == 0){
						isCheked = false;
					}
					//console.log(data);
					//console.log(arr);
					
					let htmlContent = "";
					
					arr.forEach(item => {
						htmlContent += `
							<div class="party-item">
								<a href="/party/board/home.jsp?no=\${item.no}">        
					            	<div class="img">
					                	<img src="/resources/images/thumbnail/\${item.filename}" alt="">
					            	</div>
					            	<div class="content">
					                	<span class="title">\${item.name}</span>
					                	<span class="description">\${item.description}</span>
					                	<div class="category">
					                    	<span class="text">\${item.category.name}</span>
					                	</div>
					                	<div class="info">
					                    	<span>\${item.quota}/\${item.curCnt}명</span>
					                    	<span>&#183</span>
					                    	<span>리더 \${item.manager.nickname}</span>
					                	</div>
					            	</div>
					        	</a>
					    	</div>
						`
					})
					document.querySelector("#party-list").innerHTML = htmlContent;
				}
			})
			console.log(currentPage);
			console.log(catNo);
			console.log(value);
			xhr.open("GET", "get-parties.jsp?pageNo=" + currentPage + "&catNo=" + catNo + "&value=" + value);
			xhr.send(null);
		} else {
			document.querySelector("#party-list").innerHTML += htmlContent;
		}
		currentPage++;
	}
</script>
</body>
</html>