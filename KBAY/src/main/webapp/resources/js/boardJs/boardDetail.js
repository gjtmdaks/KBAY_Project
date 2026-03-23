function deletePost(boardNo, boardCdNo) {
    if(confirm("정말 이 게시글을 삭제하시겠습니까?")) {
        
        let url = '/kbay/board/deletePost?boardNo=' + boardNo;
        
        if (boardCdNo !== undefined) {
            url += '&boardCdNo=' + boardCdNo;
        }
        
        location.href = url;
    }
}