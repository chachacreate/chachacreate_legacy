<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 관리자 페이지</title>
<link rel="stylesheet" type="text/css" href="resources/css/admin/authMain.css">
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
	                    <li><a href="storeSettlementContent.jsp" class="menu-link">스토어 정산 관리</a></li>
	                    <li><a href="#" class="menu-link">개인 판매자 정산 관리</a></li>
	                </ul>
	            </li>
	            <li class="has-submenu">
	                <a href="javascript:void(0);">건의/신고 관리 ▼</a>
	                <ul class="submenu">
	                    <li><a href="#" class="menu-link">건의사항</a></li>
	                    <li><a href="#" class="menu-link">신고</a></li>
	                </ul>
	            </li>
	            <li><a href="#" class="menu-link">스토어 관리</a></li>
	            <li><a href="#" class="menu-link">회원 관리</a></li>
	        </ul>
	    </nav>

	    <main class="content" id="content-area">
	        <!-- 처음 기본 화면 -->
	        <div class="summary-box">
	            <div class="summary-item">
	                <div class="icon">🏪</div>
	                <div class="summary-title">스토어 개설 요청</div>
	                <div class="summary-info">
	                    <span>신규 <span class="count">10</span></span>
	                    <span>미처리 <span class="count">10</span></span>
	                </div>
	            </div>
	            <div class="summary-item">
	                <div class="icon">📄</div>
	                <div class="summary-title">건의 사항</div>
	                <div class="summary-info">
	                    <span>신규 <span class="count">10</span></span>
	                    <span>미처리 <span class="count">10</span></span>
	                </div>
	            </div>
	            <div class="summary-item">
	                <div class="icon">🚩</div>
	                <div class="summary-title">신고</div>
	                <div class="summary-info">
	                    <span>신규 <span class="count">10</span></span>
	                    <span>미처리 <span class="count">10</span></span>
	                </div>
	            </div>
	        </div>
	        
	        <div class="balance-box">
                <div class="balance-label">현재 계좌 잔액</div>
                <div class="balance-amount">1,123,165,400원</div>
            </div>

            <div class="balance-box">
                <div class="balance-label">판매자 정산 예정 금액</div>
                <div class="balance-amount">894,456,400원</div>
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

        $('.menu-link').click(function(e) {
            e.preventDefault();  // 기존 a태그 링크 이동 막기

            var url = $(this).attr('href');
            if (url && url !== '#') {
                $('#content-area').load(url);
            }
        });
    });
</script>

</body>
</html>
