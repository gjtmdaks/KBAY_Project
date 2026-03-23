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
					<option value="2">예술</option>
					<option value="3">도서/문헌</option>
					<option value="4">근현대생활사</option>
					<option value="5">컬렉터블</option>
					<option value="6">세컨핸드(중고)</option>
					<option value="7">키덜트</option>
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
				<small id="priceGuide"
					style="color: #666; font-size: 12px; display: none;"> * 시작
					가격의 30% 이상 가격으로 설정해야 합니다. </small>
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
				<label for="sizeUnit">물품 사이즈</label> <select id="sizeUnit"
					name="sizeUnit">
					<option value="cm">cm (센티미터)</option>
					<option value="inch">inch (인치)</option>
					<option value="㎡">㎡ (제곱미터)</option>
					<option value="kg">kg (킬로그램)</option>
				</select>
			</div>

			<div class="form-group">
				<label for="itemSize">물품 크기</label> <input type="number"
					id="itemSize" name="itemSize" step="10" min="0"
					placeholder="단위에 맞는 수치를 입력하세요">
			</div>

			<div class="form-group">
				<label for="endTime">경매 종료 일시 (최대 10일)</label> <input
					type="datetime-local" id="endTime" name="endTime" required>
			</div>

			<div class="form-group">
				<label for="itemContent">상세 설명</label>
				<textarea id="itemContent" name="itemContent" rows="5" required></textarea>
				<div id="byte-counter-area"
					style="text-align: right; margin-top: 5px; font-size: 13px; color: #666;">
					<span id="nowByte">0</span> / 200 byte
				</div>
			</div>

			<div class="form-group">
				<label for="upfiles">이미지 첨부</label> <input type="file" id="upfiles"
					name="upfiles" accept="image/*" multiple required>
				<div id="image-preview-container"
					style="display: flex; gap: 15px; margin-top: 15px; flex-wrap: wrap;"></div>
			</div>

			<button type="submit" class="submit-btn">물품 등록하기</button>


		</form>


	</main>



	<script>
	/* 글자 바이트 계산 */
	function getByteLength(str) {
	    let b, i, c;
	    for (b = i = 0; c = str.charCodeAt(i++); b += c >> 11 ? 3 : c >> 7 ? 2 : 1);
	    return b;
	}
	
	
		document.addEventListener('DOMContentLoaded', function() {
			const directBuy = document.getElementById('directBuy');
			const buyNowPrice = document.getElementById('BuyNowPrice');
			const priceGuide = document.getElementById('priceGuide');
			const sizeUnit = document.getElementById('sizeUnit');
			const itemSize = document.getElementById('itemSize');
			const startPriceInput = document.getElementById('startPrice');
			const upfiles = document.getElementById('upfiles');
			const previewContainer = document.getElementById('image-preview-container');
			const itemContent = document.getElementById('itemContent');
		    const nowByte = document.getElementById('nowByte');
		    const byteCounterArea = document.getElementById('byte-counter-area');
		    
		    
	        buyNowPrice.addEventListener('click', function() {
	            if (this.readOnly) {
	                alert("즉시 구매 가능 여부를 '가능'으로 먼저 변경해주세요");
	                directBuy.focus();
	            }
	        });
			
	     // 실시간 바이트 체크 이벤트
	        itemContent.addEventListener('input', function() {
	            const currentByte = getByteLength(this.value);
	            nowByte.innerText = currentByte;

	            // 200바이트를 초과하면 빨간색으로 강조
	            if (currentByte > 200) {
	                byteCounterArea.style.color = "#E74C3C"; // 경고색 (빨간색)
	                nowByte.style.fontWeight = "bold";
	            } else {
	                byteCounterArea.style.color = "#666"; // 기본색
	                nowByte.style.fontWeight = "normal";
	            }
	        });
			

				
				// 이미지 미리보기 및 개수 제한 로직
				upfiles.addEventListener('change', function(e) {
				    const files = Array.from(e.target.files); 

				    // 1. 파일 개수 체크 (최대 5개)
				    if (files.length > 5) {
				        alert("이미지 파일은 최대 5개까지만 업로드 가능합니다.");
				        this.value = ""; // 선택된 파일 초기화
				        previewContainer.innerHTML = ""; // 미리보기 영역 초기화
				        return;
				    }

				    // 2. 기존 미리보기 지우기
				    previewContainer.innerHTML = "";

				    // 3. 파일 검사 및 미리보기 생성
				    files.forEach(file => {
				        if (!file.type.match('image.*')) {
				            alert("이미지 파일만 업로드 가능합니다.");
				            this.value = "";
				            previewContainer.innerHTML = "";
				            return;
				        }

				        const reader = new FileReader();
				        reader.onload = function(event) {
				            const card = document.createElement('div');
				            card.style.cssText = "width: 120px; border: 1px solid #eee; padding: 5px; border-radius: 8px; background: #f9f9f9; text-align: center; position: relative;";

				            const delBtn = document.createElement('button');
				            delBtn.innerHTML = "&times;";
				            delBtn.style.cssText = "position: absolute; top: -5px; right: -5px; width: 20px; height: 20px; border-radius: 50%; background: #ff5f5f; color: white; border: none; cursor: pointer;";
				                
				            delBtn.onclick = function() {
				                upfiles.value = ""; 
				                previewContainer.innerHTML = "";
				            };
				        
				            const img = document.createElement('img');
				            img.src = event.target.result;
				            img.style.cssText = "width: 100%; height: 100px; object-fit: cover; border-radius: 5px;";

				            const nameLabel = document.createElement('p');
				            nameLabel.innerText = file.name;
				            nameLabel.style.cssText = "font-size: 11px; color: #555; margin-top: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;";

				            card.appendChild(delBtn);
				            card.appendChild(img);
				            card.appendChild(nameLabel);
				            previewContainer.appendChild(card);
				        };
				        reader.readAsDataURL(file);
				    });
				});

			sizeUnit.addEventListener('change', function() {
				itemSize.placeholder = this.value + "를 입력하세요";
			});

			directBuy.addEventListener('change', function() {
				if (this.value === 'Y') {
					buyNowPrice.readOnly = false;
					buyNowPrice.style.backgroundColor = "#fff";
					buyNowPrice.style.cursor = "text";
					buyNowPrice.value = "";
					priceGuide.style.display = "block";
				} else {
					buyNowPrice.readOnly = true;
					buyNowPrice.style.backgroundColor = "#f1f1f1";
					buyNowPrice.style.cursor = "not-allowed";
					buyNowPrice.value = "0";
					priceGuide.style.display = "none";
				}
			});

			document.getElementById('enrollForm').addEventListener('submit', function(e) {
			    // 1. 값 가져오기
			    const itemTitle = document.getElementById('itemTitle').value;
			    const itemContent = document.getElementById('itemContent').value;
			    const sPrice = parseInt(startPriceInput.value);
			    const bPrice = parseInt(buyNowPrice.value);
			    const iSize = parseInt(document.getElementById('itemSize').value); // 물품 크기
			    

			    // 2. 물품명 제한 (25글자 & 50byte)
			    if (itemTitle.length > 20 || getByteLength(itemTitle) > 50) {
			        alert("물품명은 15글자 이내로 입력해주세요.");
			        document.getElementById('itemTitle').focus();
			        e.preventDefault();
			        return;
			    }

			    // 3. 가격 상한선 체크 (시작가 1억, 즉시구매가 10억)
			    if (sPrice > 100000000) {
			        alert("시작 가격은 1억 원을 초과할 수 없습니다.");
			        startPriceInput.focus();
			        e.preventDefault();
			        return;
			    }
			    
			    if (directBuy.value === 'Y' && bPrice > 1000000000) {
			        alert("즉시 구매 가격은 10억 원을 초과할 수 없습니다.");
			        buyNowPrice.focus();
			        e.preventDefault();
			        return;
			    }

			    // 4. 물품 크기/수량 제한 (최대 10,000)
			    if (iSize > 10000) {
			        alert("물품 크기 수치는 최대 10,000까지만 입력 가능합니다.");
			        document.getElementById('itemSize').focus();
			        e.preventDefault();
			        return;
			    }

			    // 5. 상세 설명 제한 (100글자 & 200byte)
			    if (itemContent.length > 100 || getByteLength(itemContent) > 200) {
			        alert("물품에 대한 상세 설명은 100글자 이내(200byte)로 입력해주세요.");
			        document.getElementById('itemContent').focus();
			        e.preventDefault();
			        return;
			    }

			    // 6. 가격 단위 및 조건 체크 
			    if (sPrice % 1000 !== 0 || (directBuy.value === 'Y' && bPrice % 1000 !== 0)) {
			        alert("가격은 1000원 단위로만 입력이 가능합니다.");
			        e.preventDefault();
			        return;
			    }
			    
			    // 7. 즉시 구매 가격 조건
			    if (directBuy.value === 'Y') {
			        const minPrice = sPrice * 1.3;
			        if (bPrice < minPrice) {
			            alert("즉시 구매 가격은 시작 가격의 30% 이상 높아야 합니다.\n(최소 금액: " + Math.ceil(minPrice) + "원)");
			            buyNowPrice.focus();
			            e.preventDefault();
			            return;
			        }
			    }
			});
			 
			// 8. 이미지 파일 개수 확인
			const fileInput = document.getElementById('upfiles');
    		if (fileInput.files.length > 5) {
    	     alert("이미지는 최대 5장까지만 등록 가능합니다.");
   		     e.preventDefault();
   		     return;
 	    	}
	
			// 날짜 제한 설정
			const now = new Date();
			const tenDaysLater = new Date();
			tenDaysLater.setDate(now.getDate() + 10);

			function formatDate(date) {
				const tzOffset = date.getTimezoneOffset() * 60000;
				return new Date(date - tzOffset).toISOString().slice(0, 16);
			}

			const endTimeInput = document.getElementById('endTime');
			endTimeInput.min = formatDate(now);
			endTimeInput.max = formatDate(tenDaysLater);
		});
	</script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>