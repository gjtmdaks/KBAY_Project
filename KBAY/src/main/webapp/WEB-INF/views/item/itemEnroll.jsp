<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>K-Bay 경매 물품 등록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/itemCss/itemEnroll.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<main class="enroll-container">
		<h2 class="section-title">경매 물품 등록</h2>

		<form action="${pageContext.request.contextPath}/auction/insert"
			method="post" enctype="multipart/form-data" id="enrollForm">

			<div class="form-group">
				<label for="itemCdNo">카테고리</label> <select id="itemCdNo"
					name="itemCdNo">
					<option value="1">디지털/가전</option>
					<option value="2">의류/잡화</option>
					<option value="3">도서/티켓</option>
				</select>
			</div>

			<div class="form-group">
				<label for="itemTitle">물품명</label> <input type="text" id="itemTitle"
					name="itemTitle" required>
			</div>

			<div class="form-group">
				<label for="startPrice">경매 시작 가격 (원)</label> <input type="number"
					id="startPrice" name="startPrice" step="1000" min="1000"
					placeholder="1000원 단위로 입력" required>
			</div>

			<div class="form-group">
				<label for="directBuy">즉시 구매 가능 여부</label> <select id="directBuy"
					name="directBuy">
					<option value="N">불가능</option>
					<option value="Y">가능</option>
				</select>
			</div>

			<div class="form-group">
				<label for="BuyNowPrice">즉시 구매 가격 (원)</label> <input type="number"
					id="BuyNowPrice" name="buyNowPrice" step="1000" min="0" value="0"
					readonly style="background-color: #f1f1f1; cursor: not-allowed;">
			</div>

			<div class="form-group">
				<label for="countryNo">제조국</label> <select id="countryNo"
					name="countryNo" required>
					<option value="">국가 선택</option>
					<option value="KOR">대한민국</option>
					<option value="USA">미국</option>
					<option value="JPN">일본</option>
					<option value="CHN">중국</option>
					<option value="FRA">프랑스</option>
					<option value="DEU">독일</option>
					<option value="RUS">러시아</option>
					<option value="BRA">브라질</option>
					<option value="IND">인도</option>
					<option value="CAN">캐나다</option>
					<option value="AUS">호주</option>
					<option value="ESP">스페인</option>
					<option value="ITA">이탈리아</option>
					<option value="ZAF">남아프리카공화국</option>
					<option value="MEX">멕시코</option>
					<option value="SWE">스웨덴</option>
					<option value="NOR">노르웨이</option>
					<option value="FIN">핀란드</option>
					<option value="GBR">영국</option>
					<option value="ETC">기타 국가</option>
				</select>
			</div>

			<div class="form-group">
				<label for="item_Size">물품 사이즈(cm)</label> <input type="number"
					id="item_Size" name="item_Size" step="10" min="0"
					placeholder="10 단위로 입력">
			</div>

			<div class="form-group">
				<label for="endTime">경매 종료 일시 (최대 10일)</label> <input
					type="datetime-local" id="endTime" name="endTime" required>
			</div>

			<div class="form-group">
				<label for="itemContent">상세 설명</label>
				<textarea id="itemContent" name="itemContent" rows="5" required></textarea>
			</div>

			<div class="form-group">
				<label for="upfiles">이미지 첨부</label> <input type="file" id="upfiles"
					name="upfiles" accept="image/*" multiple required>
			</div>

			<button type="submit" class="submit-btn">물품 등록하기</button>


		</form>


	</main>
	<script>
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {
							const directBuy = document
									.getElementById('directBuy');
							const buyNowPrice = document
									.getElementById('BuyNowPrice');
							const endTimeInput = document
									.getElementById('endTime');

							// 1. 즉시 구매가 활성화 로직
							directBuy
									.addEventListener(
											'change',
											function() {
												if (this.value === 'Y') {
													buyNowPrice.readOnly = false;
													buyNowPrice.style.backgroundColor = "#fff";
													buyNowPrice.style.cursor = "text";
													buyNowPrice.value = ""; // 입력하기 편하게 초기화
												} else {
													buyNowPrice.readOnly = true;
													buyNowPrice.style.backgroundColor = "#f1f1f1";
													buyNowPrice.style.cursor = "not-allowed";
													buyNowPrice.value = "0";
												}
											});

							// 비활성화 상태에서 클릭 시 알림
							buyNowPrice.addEventListener('click', function() {
								if (this.readOnly) {
									alert("즉시 구매 가능 여부를 '가능'으로 먼저 변경해주세요!");
									directBuy.focus();
								}
							});

							// 2. 경매 종료 일시 제한 (현재~10일 후)
							const now = new Date();
							const tenDaysLater = new Date();
							tenDaysLater.setDate(now.getDate() + 10);

							// datetime-local 형식(YYYY-MM-DDTHH:mm)으로 변환 함수
							function formatDate(date) {
								const tzOffset = date.getTimezoneOffset() * 60000; // 로컬 시간 보정
								return new Date(date - tzOffset).toISOString()
										.slice(0, 16);
							}

							endTimeInput.min = formatDate(now);
							endTimeInput.max = formatDate(tenDaysLater);

							// 3. 1000원 단위 입력 검증 (제출 전 확인)
							document
									.getElementById('enrollForm')
									.addEventListener(
											'submit',
											function(e) {
												const startPrice = document
														.getElementById('startPrice').value;
												const bPrice = buyNowPrice.value;

												if (startPrice % 1000 !== 0
														|| (directBuy.value === 'Y' && bPrice % 1000 !== 0)) {
													alert("가격은 1000원 단위로만 입력이 가능합니다.");
													e.preventDefault(); // 제출 방지
												}
											});
						});
	</script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>