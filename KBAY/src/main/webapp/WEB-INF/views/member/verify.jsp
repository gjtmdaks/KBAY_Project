<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본인인증</title>

<!-- 아임포트 SDK -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
</head>

<body>
<h2>본인인증 진행중...</h2>

<script>
	var IMP = window.IMP;
	IMP.init("imp76617108"); // 👉 여기에 가맹점 식별코드 넣기

    function startVerification() {

        IMP.certification({
        	pg: "inicis",
            merchant_uid: "cert_" + new Date().getTime()
        }, function (rsp) {

            if (rsp.success) {

                // 🔥 서버로 imp_uid 전달
                fetch('${pageContext.request.contextPath}/member/verify', {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({
                        imp_uid: rsp.imp_uid
                    })
                })
                .then(res => res.text())
                .then(result => {

                    if (result === "success") {

                        alert("본인인증 완료");

                        if (window.opener) {
                            window.opener.isVerified = true;
                            window.opener.location.reload();
                        }

                        window.close();

                    } else if (result === "mismatch") {
                        alert("회원 정보와 인증 정보가 일치하지 않습니다.");
                    } else {
                        alert("인증 처리 실패");
                    }
                });

            } else {
                alert("인증 실패: " + rsp.error_msg);
                window.close();
            }
        });
    }

    // 자동 실행
    startVerification();
</script>

</body>
</html>