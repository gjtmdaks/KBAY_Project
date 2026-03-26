<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reportCss/report.css">
<div id="reportPopup" style="display:none;">
    <h3>신고 사유 선택</h3>

    <form id="reportForm">
        <input type="hidden" id="targetType">
        <input type="hidden" id="targetNo">

        <label><input type="radio" name="reportCdNo" value="1"> 음란/선정성</label><br>
        <label><input type="radio" name="reportCdNo" value="2"> 명예훼손 및 욕설</label><br>
        <label><input type="radio" name="reportCdNo" value="3"> 불법 및 사기</label><br>
        <label><input type="radio" name="reportCdNo" value="4"> 도배 및 홍보</label><br>
        <label><input type="radio" name="reportCdNo" value="5"> 저작권 침해</label><br>
        <label><input type="radio" name="reportCdNo" value="5"> 판매 제한 물품</label><br>
        <label><input type="radio" name="reportCdNo" value="5"> 유해 화학물질</label><br>
        <label><input type="radio" name="reportCdNo" value="5"> 기타</label><br>

        <button type="button" onclick="submitReport()">신고</button>
        <button type="button" onclick="closeReportPopup()">취소</button>
    </form>
</div>