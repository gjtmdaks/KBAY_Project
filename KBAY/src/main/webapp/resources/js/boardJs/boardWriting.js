document.addEventListener('DOMContentLoaded', function() {
    const dropZone = document.getElementById('dropZone');
    const fileInput = document.getElementById('fileInput');
    const fileList = document.getElementById('fileList');
    let uploadedFiles = []; // 실제 폼 전송 시 사용할 파일 배열

    // 1. 박스 클릭 시 일반적인 파일 선택 창 열기
    dropZone.addEventListener('click', () => fileInput.click());

    // 2. 파일 선택 창에서 파일 선택 시
    fileInput.addEventListener('change', (e) => {
        handleFiles(e.target.files);
    });

    // 3. 파일이 드롭존 위에 올라왔을 때 (시각적 효과 추가)
    dropZone.addEventListener('dragover', (e) => {
        e.preventDefault(); // 필수: 기본 동작 방지
        dropZone.classList.add('dragover');
    });

    // 4. 파일이 드롭존을 벗어났을 때 (시각적 효과 제거)
    dropZone.addEventListener('dragleave', () => {
        dropZone.classList.remove('dragover');
    });

    // 5. 파일을 드롭존에 떨어뜨렸을 때
    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.classList.remove('dragover');
        handleFiles(e.dataTransfer.files); // 드래그한 파일 데이터 넘기기
    });
	
    function handleFiles(files) {
        if (uploadedFiles.length + files.length > 5) {
            
            alert(`파일은 최대 5개까지만 업로드 가능합니다.`);
            
            return; // 5개가 넘어가면 함수 종료 (더 이상 추가 안 함)
        }

        for (const file of files) {
            uploadedFiles.push(file);
        }
        updateFileList(); 
    }

    function updateFileList() {
        fileList.innerHTML = ''; 
        const dataTransfer = new DataTransfer(); 

        uploadedFiles.forEach((file, index) => {
            dataTransfer.items.add(file); 

            // 1. 전체 한 줄(li) 태그 생성
            const li = document.createElement('li');
            li.classList.add('file-item'); 

            // 2. 이미지 미리보기 또는 아이콘 영역 만들기
            const previewWrapper = document.createElement('div');
            previewWrapper.classList.add('file-preview-wrapper');

            // 파일 종류 확인 (예: image/jpeg, image/png 등)
            if (file.type.startsWith('image/')) {
                // A. 이미지 파일일 때: 진짜 미리보기 <img> 태그 생성
                const img = document.createElement('img');
                img.classList.add('file-preview-img');
                img.alt = file.name;

                // 브라우저의 마법 스캐너(FileReader)로 이미지 읽기
                const reader = new FileReader();
                reader.onload = function(e) {
                    // 스캔이 끝나면 <img> 태그의 src에 데이터 넣어주기!
                    img.src = e.target.result; 
                }
                reader.readAsDataURL(file); // 이미지 스캔 시작

                previewWrapper.appendChild(img);
            } else {
                // B. 이미지가 아닐 때: 기존처럼 클립 아이콘(📎) 보여주기
                const iconSpan = document.createElement('span');
                iconSpan.classList.add('file-preview-icon');
                iconSpan.textContent = '📎';
                previewWrapper.appendChild(iconSpan);
            }

            // 3. 파일 이름과 용량 정보 영역
            const fileInfo = document.createElement('div');
            fileInfo.classList.add('file-info-text');
            
            const fileNameSpan = document.createElement('span');
            fileNameSpan.classList.add('file-name');
            fileNameSpan.textContent = file.name;
            
            const fileSizeSpan = document.createElement('span');
            fileSizeSpan.classList.add('file-size');
            fileSizeSpan.textContent = ` (${(file.size / 1024).toFixed(1)} KB)`;
            
            fileInfo.appendChild(fileNameSpan);
            fileInfo.appendChild(fileSizeSpan);
            
            // 4. 삭제 버튼(X) 만들기
            const deleteBtn = document.createElement('button');
            deleteBtn.textContent = '❌';
            deleteBtn.type = 'button';
            deleteBtn.classList.add('btn-delete-file');
            
            deleteBtn.addEventListener('click', function(e) {
                e.stopPropagation(); 
                uploadedFiles.splice(index, 1); 
                updateFileList(); 
            });

            // 5. 최종 조립하기 (순서 중요!)
            li.appendChild(previewWrapper); // 미리보기/아이콘 (왼쪽)
            li.appendChild(fileInfo);       // 이름/용량 (가운데)
            li.appendChild(deleteBtn);      // 삭제버튼 (오른쪽)
            
            fileList.appendChild(li);
        });

        fileInput.files = dataTransfer.files;
    }
});

