function deletePost(boardNo) {
    if(confirm("정말 이 게시글을 삭제하시겠습니까?")) {
        location.href = "delete.bo?bno=" + boardNo;
    }
}