<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 정보 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/updateStatus.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<section class="mypage-container">

    <aside class="mypage-sidebar">
        <jsp:include page="mypageSidebar.jsp" />
    </aside>

    <main class="mypage-main">

        <h2>내 정보 수정</h2>

        <form action="${pageContext.request.contextPath}/mypage/updateStatus" method="post">

            <table class="mypage-table">

                <tr>
                    <th>아이디</th>
                    <td>
                        <input type="text" name="userId" value="${user.userId}" readonly>
                    </td>
                </tr>

                <tr>
                    <th>이름</th>
                    <td>
                        <input type="text" name="userName" value="${user.userName}">
                    </td>
                </tr>

                <tr>
                    <th>주소</th>
                    <td>
                        <input type="text" name="userAddress" value="${user.userAddress}">
                    </td>
                </tr>

                <tr>
                    <th>전화번호</th>
                    <td>
                        <input type="text" name="userPhone" value="${user.userPhone}">
                    </td>
                </tr>

                <tr>
                    <th>이메일</th>
                    <td>
                        <input type="email" name="userEmail" value="${user.userEmail}">
                    </td>
                </tr>

                <tr>
                    <th>가입일</th>
                    <td>
                        <input type="text"
                        	value="<fmt:formatDate value='${user.userEnrollDate}' pattern='yyyy-MM-dd HH:mm:ss'/>"
                        	readonly>
                    </td>
                </tr>

            </table>

            <div>
            	<div class="btn-out">
            		<button type="button" class="btn-submit">회원 탈퇴</button>
            	</div>
                <div class="btn-area">
    	            <button type="submit" class="btn-submit">수정하기</button>
	                <button type="button" class="btn-submit" onclick="history.back()">취소</button>
                </div>
            </div>
        </form>
    </main>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>