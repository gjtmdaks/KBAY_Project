function deletePost(boardNo, boardCdNo) {
    if(confirm("정말 이 게시글을 삭제하시겠습니까?")) {
        
        let url = '/kbay/board/deletePost?boardNo=' + boardNo;
        
        if (boardCdNo !== undefined) {
            url += '&boardCdNo=' + boardCdNo;
        }
        
        location.href = url;
    }
}

// 댓글 등록
function insertReply(boardNo) {
    // 적은 글자가져오기
    let content = $("#replyContent").val();

    // 2. 빈칸 검사
    if (content.trim() === "") {
        alert("댓글 내용을 입력해주세요!");
        $("#replyContent").focus();
        return;
    }

    $.ajax({
        url: "/kbay/board/insertReply",
        type: "POST",
        data: {
            boardNo: boardNo,
            replyContent: content
        },
        success: function(result) {
            if (result === "success") {
                $("#replyContent").val("")
                location.reload(); 
            } else {
                alert("댓글 등록에 실패했습니다. 다시 시도해 주세요.");
            }
        },
        error: function() {
            alert("통신 에러");
        }
    });
}

// 댓글 삭제
function deleteReply(replyNo) {
    if (confirm("정말 이 댓글을 삭제하시겠습니까?")) {
        $.ajax({
            url: "/kbay/board/deleteReply", 
            type: "POST", 
            data: { replyNo: replyNo },
            success: function(result) {
                if (result === "success") {
                    alert("댓글이 삭제되었습니다.");
                    location.reload();
                } else {
                    alert("삭제 실패 다시 시도해 주세요.");
                }
            },
            error: function() {
                alert("삭제 중 통신 에러 발생");
            }
        });
    }
}