/* 글자 바이트 계산 */
function getByteLength(str) {
    let b, i, c;
    for (b = i = 0; c = str.charCodeAt(i++); b += c >> 11 ? 3 : c >> 7 ? 2 : 1);
    return b;
}

document.addEventListener('DOMContentLoaded', function() {
    // 공통 DOM 요소 가져오기
    const directBuy = document.getElementById('directBuy');
    const buyNowPrice = document.getElementById('BuyNowPrice');
    const priceGuide = document.getElementById('priceGuide');
    const sizeUnit = document.getElementById('sizeUnit');
    const itemSize = document.getElementById('itemSize');
    const startPriceInput = document.getElementById('startPrice');
    const itemContent = document.getElementById('itemContent');
    const nowByte = document.getElementById('nowByte');
    const byteCounterArea = document.getElementById('byte-counter-area');
    const startTimeInput = document.getElementById('startTime');
    const endTimeInput = document.getElementById('endTime');
    
    const fileInput = document.getElementById('upfiles');
    const previewContainer = document.getElementById('image-preview-container');
    const dropZone = document.getElementById('dropZone');

    // 날짜 및 시간 제어 로직
    function formatDate(date){
        const tzOffset  = date.getTimezoneOffset() * 60000;
        return new Date(date - tzOffset).toISOString().slice(0,16);
    }
    
    const now = new Date();
    const twoWeeksLater = new Date();
    twoWeeksLater.setDate(now.getDate() + 14);
    
    startTimeInput.min = formatDate(now);
    startTimeInput.max = formatDate(twoWeeksLater);
    
    startTimeInput.addEventListener('change',function(){
        const selectedStart = new Date(this.value);
        endTimeInput.min = formatDate(selectedStart);
        
        const maxEnd = new Date(selectedStart);
        maxEnd.setDate(selectedStart.getDate() + 10);
        endTimeInput.max = formatDate(maxEnd);
        
        if(endTimeInput.value && (new Date(endTimeInput.value)< selectedStart || new Date(endTimeInput.value) > maxEnd)){
            endTimeInput.value = "";
        }
    });

    // UI 및 실시간 바이트 체크 이벤트
    buyNowPrice.addEventListener('click', function() {
        if (this.readOnly) {
            alert("즉시 구매 가능 여부를 '가능'으로 먼저 변경해주세요");
            directBuy.focus();
        }
    });
    
    itemContent.addEventListener('input', function() {
        const currentByte = getByteLength(this.value);
        nowByte.innerText = currentByte;
        if (currentByte > 3000) {
            byteCounterArea.style.color = "#E74C3C"; 
            nowByte.style.fontWeight = "bold";
        } else {
            byteCounterArea.style.color = "#666"; 
            nowByte.style.fontWeight = "normal";
        }
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

    // 파일 업로드, 드래그 앤 드롭 추가
    let uploadedFiles = []; 

    dropZone.addEventListener('dragover', (e) => {
        e.preventDefault(); 
        dropZone.style.backgroundColor = '#f4f9f4'; 
        dropZone.style.border = '2px dashed #4CAF50'; 
    });

    dropZone.addEventListener('dragleave', (e) => {
        e.preventDefault();
        dropZone.style.backgroundColor = '';
        dropZone.style.border = '';
    });

    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.style.backgroundColor = ''; 
        dropZone.style.border = '';
        handleFiles(e.dataTransfer.files); 
    });

    fileInput.addEventListener('change', (e) => {
        handleFiles(e.target.files);
    });

    function handleFiles(files) {
        // 기존 파일 개수 + 새로 추가할 파일 개수가 5개를 넘는지 확인!
        if (uploadedFiles.length + files.length > 5) {
            alert("이미지 파일은 최대 5개까지만 업로드 가능합니다.");
            return; // 5개 넘으면 아예 안 받음!
        }

        for (const file of files) {
            if (file.type.startsWith('image/')) {
                uploadedFiles.push(file); 
            } else {
                alert("이미지 파일만 첨부할 수 있습니다.");
            }
        }
        updateFileList(); 
    }

    function updateFileList() {
        previewContainer.innerHTML = ''; 
        const dataTransfer = new DataTransfer(); 

        uploadedFiles.forEach((file, index) => {
            dataTransfer.items.add(file); 

            // 박스 생성
            const div = document.createElement('div');
            div.style.cssText = "position: relative; width: 120px; height: 120px; border-radius: 8px; border: 1px solid #ddd; overflow: hidden; background: #f9f9f9;";

            // 이미지 생성
            const img = document.createElement('img');
            img.style.cssText = "width: 100%; height: 100%; object-fit: cover;";
            
            const reader = new FileReader();
            reader.onload = function(e) { img.src = e.target.result; }
            reader.readAsDataURL(file);

            // 삭제 버튼 생성
            const deleteBtn = document.createElement('button');
            deleteBtn.innerHTML = '✖';
            deleteBtn.type = 'button';
            deleteBtn.style.cssText = "position: absolute; top: 5px; right: 5px; width: 24px; height: 24px; background-color: rgba(255, 0, 0, 0.8); color: white; border: none; border-radius: 50%; cursor: pointer; display: flex; justify-content: center; align-items: center; font-size: 12px;";

            deleteBtn.addEventListener('click', function(e) {
                e.preventDefault();
                uploadedFiles.splice(index, 1); // 배열에서 삭제
                updateFileList(); // 화면 갱신
            });

            // 조립
            div.appendChild(img);
            div.appendChild(deleteBtn);
            previewContainer.appendChild(div);
        });

        // 폼 제출용 데이터 덮어쓰기
        fileInput.files = dataTransfer.files;
    }

    // 폼 제출 전 최종 검증 (Submit)
    document.getElementById('enrollForm').addEventListener('submit', function(e) {
        const itemTitle = document.getElementById('itemTitle').value;
        const sPrice = parseInt(startPriceInput.value);
        const bPrice = parseInt(buyNowPrice.value);
        const iSize = parseInt(itemSize.value); 
        const start = new Date(startTimeInput.value);
        const end = new Date(endTimeInput.value);
        const diffDays = (end - start) / (1000 * 60 * 60 * 24);
        
           if (itemTitle.length > 30 || getByteLength(itemTitle) > 100) {
            alert("물품명은 30글자 이내로 입력해주세요.");
            document.getElementById('itemTitle').focus();
            e.preventDefault(); return;
        }

        if (sPrice > 100000000) {
            alert("시작 가격은 1억 원을 초과할 수 없습니다.");
            startPriceInput.focus();
            e.preventDefault(); return;
        }
        
        if (directBuy.value === 'Y' && bPrice > 1000000000) {
            alert("즉시 구매 가격은 10억 원을 초과할 수 없습니다.");
            buyNowPrice.focus();
            e.preventDefault(); return;
        }

        if (iSize > 10000) {
            alert("물품 크기 수치는 최대 10,000까지만 입력 가능합니다.");
            itemSize.focus();
            e.preventDefault(); return;
        }

        if (getByteLength(itemContent.value) > 3000) {
            alert("물품에 대한 상세 설명은 3000byte 이내로 입력해주세요.");
            itemContent.focus();
            e.preventDefault(); return;
        }

        if (sPrice % 1000 !== 0 || (directBuy.value === 'Y' && bPrice % 1000 !== 0)) {
            alert("가격은 1000원 단위로만 입력이 가능합니다.");
            e.preventDefault(); return;
        }
        
        if (directBuy.value === 'Y') {
            const minPrice = sPrice * 1.3;
            if (bPrice < minPrice) {
                alert("즉시 구매 가격은 시작 가격의 30% 이상 높아야 합니다.\n(최소 금액: " + Math.ceil(minPrice) + "원)");
                buyNowPrice.focus();
                e.preventDefault(); return;
            }
        }
        
        
        if (uploadedFiles.length > 15) {
             alert("이미지는 최대 15장까지만 등록 가능합니다.");
             e.preventDefault(); return;
        }

        if (start >= end) {
            alert("경매 종료 시간은 시작 시간보다 이후여야 합니다.");
            e.preventDefault(); return;
        }
        
        if (diffDays > 10) {
            alert("경매 기간은 시작 시간으로부터 최대 10일 이내여야 합니다.");
            e.preventDefault(); return;
        }
    });
});