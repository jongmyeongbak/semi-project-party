function redirectToLogin() {
	let originalUrl = window.location.href;
	window.location.href = "/login-form.jsp?redirect=" + encodeURIComponent(originalUrl);
}

const tabContainer = document.getElementById("party-container");

tabContainer.addEventListener('click', function(e) {
	if (e.target.classList.contains('withdraw')) {
		if (confirm("탈퇴하시겠습니까?")) {
			let no = e.target.getAttribute('data-no');
			withdrawParty(e, no);
		}
	}
});

function withdrawParty(e, no) {
	let xhr = new XMLHttpRequest();
	xhr.onload = function() {
		if (xhr.status === 200) {
			alert("탈퇴되었습니다.");
			e.target.closest('tr').remove();
		} else if (xhr.status === 401) {
			alert("로그인이 필요합니다.");
			redirectToLogin();
		}
	}
	xhr.open("Get", "withdraw.jsp?no=" + no);
	xhr.send(null);
}

tabContainer.addEventListener('click', function(e) {
	if (e.target.classList.contains('fa-regular')) {
		const no = e.target.closest('tr').getAttribute('data-no');
		togglePartyFavorite(e, no, 'add');
	}
	if (e.target.classList.contains('fa-solid')) {
		const no = e.target.closest('tr').getAttribute('data-no');
		togglePartyFavorite(e, no, 'del');
	}
});

function togglePartyFavorite(e, no, op) {
	//
	let xhr = new XMLHttpRequest();
	xhr.onload = function() {
		if (xhr.status === 200) {
			if (op == 'add') {
				e.target.classList.add('fa-solid');
				e.target.classList.remove('fa-regular');
			} else {
				e.target.classList.add('fa-regular');
				e.target.classList.remove('fa-solid');
			}
			const favoriteTab = document.getElementById('favorite');
			if (favoriteTab.classList.contains('active')) {
				switchTab(favoriteTab);
			}
		} else if (xhr.status === 401) {
			alert("로그인이 필요합니다.");
			redirectToLogin();
		}
	}
	xhr.open("Get", "toggleFavorite.jsp?no=" + no + "&op=" + op);
	xhr.send(null);
}

const partyTabs = document.querySelector(".tabs");
partyTabs.addEventListener('click', function(e) {
	if (e.target.classList.contains('tab')) {
		switchTab(e.target);
	}
});

function switchTab(el) {
	let xhr = new XMLHttpRequest();
	xhr.onload = function() {
		console.log("Received response: ", xhr.status, xhr.responseText);
		if (xhr.status === 200) {
			console.log("ddd ", xhr.status, xhr.responseText);
			let partyList = JSON.parse(xhr.responseText);
			if (partyList.length === 0) {
				let tabMsg;
				if (el.id === "favorite") {
					tabMsg = "즐겨찾는";
				} else if (el.id === "managed") {
					tabMsg = "운영하는";
				} else {
					tabMsg = "가입한";
				}
				tabContainer.innerHTML = '<tr><td colspan="3">' + tabMsg + ' 파티가 없습니다.</td></tr>';
			} else {
				let partyHtml = '';
				partyList.forEach(function(party) {
					partyHtml += '<tr data-no=' + party.no + '>';
						partyHtml += '<td><i class="' + (party.isFavorite ? 'fa-solid' : 'fa-regular') + ' fa-star fa-lg"></i></td>';
						partyHtml += '<td><img src="/images/thumbnail/' + (party.filename === undefined ? 'sample.jpg' : party.filename) + '">' + party.name + '</td>';
						partyHtml += '<td>';
						if (party.isManaged) {
							partyHtml += '<button type="button" class="manage">관리</button>';
						} else {
							partyHtml += '<button type="button" class="withdraw">탈퇴</button>';
						}
						partyHtml += '</td>';
					partyHtml += '</tr>';
				});
				tabContainer.innerHTML = partyHtml;
			}
			const tabElements = partyTabs.getElementsByClassName('tab');
			for (let i = 0; i < tabElements.length; i++) {
				tabElements[i].classList.remove('active');
			}
			el.classList.add('active');
		} else if (xhr.status === 401) {
			alert("로그인이 필요합니다.");
			redirectToLogin();
		}
	}
	xhr.open("Get", "get-my-parties.jsp?tab=" + el.id, false);
	xhr.send(null);
}