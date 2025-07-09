<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 관리자 페이지</title>
<%@ include file="/common/header.jsp"%>
<link rel="stylesheet" href="${cpath}/resources/css/admin/authMain.css">
<link rel="stylesheet" href="${cpath}/resources/css/admin/storeSettlementManage.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<div class="wrapper">

<header>
    <div class="header-inner">
        <div class="login-bar">
            <span>관리자님 반갑습니다.</span>
            <button class="logout-btn">로그아웃</button>
        </div>
    </div>
</header>

<div class="main-area">
	<div class="content-wrapper"> 
    <nav class="sidebar">
        <ul>
            <li class="has-submenu">
                <a href="javascript:void(0);">판매자 정산 관리 ▼</a>
                <ul class="submenu">
                    <li><a href="#">스토어 정산 관리</a></li>
                    <li><a href="#">개인 판매자 정산 관리</a></li>
                </ul>
            </li>

            <li class="has-submenu">
                <a href="javascript:void(0);">건의/신고 관리 ▼</a>
                <ul class="submenu">
                    <li><a href="#">건의사항</a></li>
                    <li><a href="#">신고</a></li>
                </ul>
            </li>

            <li><a href="#">스토어 관리</a></li>
            <li><a href="#">회원 관리</a></li>
        </ul>
    </nav>
    
    <!-- 콘텐츠 부분 -->

    <main class="content">
        <div class="content-inner">

            <div class="settlement-content">
    <h2>스토어 정산 관리</h2>

    <div class="total-summary-box">
        <span>총 정산 예정 금액 :</span>
        <strong>3,245,000원</strong>
    </div>

    <div class="settlement-table">
        <table>
            <thead>
                <tr>
                    <th>스토어명</th>
                    <th>판매자명</th>
                    <th>계좌번호</th>
                    <th>은행명</th>
                    <th>예금주명</th>
                    <th>정산금액</th>
                    <th>처리상태</th>
                    <th>정산일</th>
                </tr>
            </thead>
            <tbody>
                <!-- 미리보기 10개 -->
                <% for (int i = 1; i <= 10; i++) { %>
                <tr>
                    <td>스토어<%= i %></td>
                    <td>홍길동</td>
                    <td>123-456-789</td>
                    <td>국민은행</td>
                    <td>홍길동</td>
                    <td><%= i * 100000 %>원</td>
                    <td>정산대기</td>
                    <td>2025-06-24</td>
                </tr>
                <% } %>

                <!-- 나머지 숨겨진 20개 -->
                <% for (int i = 11; i <= 30; i++) { %>
                <tr class="extra-row" style="display:none;">
                    <td>스토어<%= i %></td>
                    <td>김철수</td>
                    <td>222-333-444</td>
                    <td>신한은행</td>
                    <td>김철수</td>
                    <td><%= i * 100000 %>원</td>
                    <td>정산완료</td>
                    <td>2025-06-23</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- 더보기 버튼 -->
    <div class="more-button-box">
        <button id="showMoreBtn">▼ 전체 보기</button>
    </div>
</div>

<!-- 콘텐츠 부분 -->
	        </div>
	    </main>
	</div>
</div>

<footer>
    &copy; 2025 뜨락상회
</footer>

</div>

<script>
    $(document).ready(function() {
        $('.has-submenu > a').click(function() {
            $(this).next('.submenu').slideToggle(200);
        });
    });
    
    $(document).ready(function() {
        $('#showMoreBtn').click(function() {
            $('.extra-row').slideDown(200);
            $(this).hide(); // 한번 클릭하면 버튼 숨기기
        });
    });
</script>

</body>
</html>
