function movePage(boardNo) {
    // boardDetail 주소로 실제 게시글 번호(boardNo)를 달고 이동합니다.
    // ※ 주의: 본인의 컨트롤러 매핑 주소에 맞게 'boardDetail' 부분을 수정해 주세요! (예: boardDetail.bo 등)
    location.href = "${contextPath}/board/boardDetail/${boardCode}/" + boardNo;
}