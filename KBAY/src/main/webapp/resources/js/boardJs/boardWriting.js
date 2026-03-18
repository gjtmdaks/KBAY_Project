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

    // 화면에 파일 목록을 그려주는 함수
    function handleFiles(files) {
        for (const file of files) {
            uploadedFiles.push(file); // 배열에 파일 저장
            
            // 화면에 <li> 태그로 파일명과 용량 추가
            const li = document.createElement('li');
            li.textContent = `📎 ${file.name} (${(file.size / 1024).toFixed(1)} KB)`;
            fileList.appendChild(li);
        }
    }
});