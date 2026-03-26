document.addEventListener('DOMContentLoaded', function() {

    // 서브메뉴 토글 버튼(신고/문의 관리) 찾기
    const toggleBtn = document.querySelector('.submenu-toggle');
    // 그 버튼을 감싸고 있는 <li> 찾기
    const parentLi = document.querySelector('.has-submenu');

    // 두 요소를 모두 화면에서 찾았을 때만 클릭 이벤트 달아주기!
    if (toggleBtn && parentLi) {
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault(); // a 태그의 기본 이동 기능 막기
            parentLi.classList.toggle('open'); // open 클래스 뗐다 붙였다 하기!
        });
    } else {
        console.log("명탐정의 로그: 사이드바 요소를 찾지 못했습니다!");
    }
});