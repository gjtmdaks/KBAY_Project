<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="reportPopup" style="display:none;">
    <h3>신고 사유 선택</h3>

    <form id="reportForm">
        <input type="hidden" id="targetType">
        <input type="hidden" id="targetNo">

        <label><input type="radio" name="reportCdNo" value="2"> 구매요망</label><br>
        <label><input type="radio" name="reportCdNo" value="3"> 결제문의</label><br>
        <label><input type="radio" name="reportCdNo" value="4"> 사기</label><br>
        <label><input type="radio" name="reportCdNo" value="5"> 기타</label><br>

        <br>

        <button type="button" onclick="submitReport()">신고</button>
        <button type="button" onclick="closeReportPopup()">취소</button>
    </form>
</div>