<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 관리자 페이지 - 신고 관리</title>
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/authMain.css">
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/declarationManage.css">
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
    
    <main class="content">
        <div class="content-inner">

            <div class="suggestion-box">
                <h2>신고 관리</h2>

                <div class="suggestion-table">
                    <table>
                        <thead>
                            <tr>
                                <th>신고자명</th>
                                <th>신고 당한 판매자/스토어</th>
                                <th>신고 내용</th>
                                <th>신고일</th>
                                <th>처리상태</th>
                            </tr>
                        </thead>
                        <tbody>
						<% for (int i = 1; i <= 30; i++) { 
						    String fullContent;
						    String reportDate;
						    if (i <= 10) {
						        fullContent = "차자가 오기에 몰렸어요. 문제가 심각해요. 사람이 너무 몰려 위험했어요.";
						        reportDate = "2025-06-24";
						    } else {
						        fullContent = "혼잡 발생 신고입니다. 개선 요청드립니다.";
						        reportDate = "2025-06-23";
						    }
						%>
						<tr <%= i > 10 ? "class='extra-row' style='display:none;'" : "" %>>
						    <td>신고자<%= i %></td>
						    <td>스토어<%= i %></td>
						    <td>
						        <div class="suggestion-content-box">
						            <span class="preview-text"><%= fullContent.length() > 30 ? fullContent.substring(0, 30) + "..." : fullContent %></span>
						            <button class="toggle-detail-btn">▼</button>
						            <div class="full-text" style="display: none;"><%= fullContent %></div>
						        </div>
						    </td>
						    <td><%= reportDate %></td>
						    <td><button class="status-btn">완료</button></td>
						</tr>
						<% } %>
						</tbody>
                    </table>
                </div>

                <div class="more-button-box">
                    <button id="showMoreBtn">▼ 전체 보기</button>
                </div>

            </div>

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

    $('#showMoreBtn').click(function() {
        $('.extra-row').slideDown(200);
        $(this).hide();
    });

    $('.toggle-detail-btn').click(function() {
        var box = $(this).closest('td');
        var fullTextDiv = box.find('.full-text');
        if (fullTextDiv.is(":visible")) {
            fullTextDiv.slideUp(200);
            $(this).text("▼");
        } else {
            fullTextDiv.slideDown(200);
            $(this).text("▲");
        }
    });

    $('.status-btn').click(function() {
        $(this).toggleClass('completed');
    });
});
</script>

</body>
</html>
