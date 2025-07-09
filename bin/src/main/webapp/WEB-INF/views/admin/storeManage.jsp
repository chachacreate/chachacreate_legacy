<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 관리자 페이지 - 스토어 관리</title>
<link rel="stylesheet" type="text/css" href="${cpath }/resources/css/admin/authMain.css">
<link rel="stylesheet" type="text/css" href="${cpath }/resources/css/admin/storeManage.css">
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

            <div class="store-box">
                <div class="store-header">
                    <h2>스토어 관리</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search">
                    </div>
                </div>

                <div class="store-table">
                    <table>
                        <thead>
                            <tr>
                                <th>스토어명</th>
                                <th>판매자명</th>
                                <th>URL</th>
                                <th>개설일</th>
                                <th>승인여부</th>
                                <th>메시지 전송</th>
                            </tr>
                        </thead>
                        <tbody>
						<% for (int i = 1; i <= 30; i++) { 
						    String storeName = (i == 1) ? "뜨락공방" : "스토어" + i;
						    String sellerName = (i == 1) ? "김지민" : "판매자" + i;
						    String storeUrl = (i == 1) ? "ttorakshop.com/store1" : "-";
						    String openDate = (i == 1) ? "2025-06-11" : "-";
						%>
						<tr <%= i > 10 ? "class='extra-row' style='display:none;'" : "" %>>
						    <td><%= storeName %></td>
						    <td><%= sellerName %></td>
						    <td><%= storeUrl %></td>
						    <td><%= openDate %></td>
						    <td><button class="status-btn <%= i == 1 ? "completed" : "" %>">완료</button></td>
						    <td><button class="open-modal-btn">메시지 전송</button></td>
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

<!-- 메시지 전송 모달 -->
<div id="messageModal" class="modal">
    <div class="modal-content">
        <h3>메시지 작성</h3>
        <div class="form-group">
            <label for="modal-title">제목:</label>
            <input type="text" id="modal-title" placeholder="제목을 입력하세요" class="modal-input">
        </div>
        <div class="form-group">
            <label for="modal-content">내용:</label>
            <textarea id="modal-content" placeholder="내용을 입력하세요" class="modal-textarea"></textarea>
        </div>
        <div class="modal-buttons">
            <button id="modal-cancel">취소</button>
            <button id="modal-submit">등록</button>
        </div>
    </div>
</div>

<!-- 승인 확인 모달 -->
<div id="confirmModal" class="modal">
    <div class="modal-content">
        <h3>승인 완료하시겠습니까?</h3>
        <div class="modal-buttons">
            <button id="confirm-cancel">취소</button>
            <button id="confirm-submit">확인</button>
        </div>
    </div>
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

    $('.open-modal-btn').click(function() {
        $('#messageModal').fadeIn();
    });

    $('#modal-cancel').click(function() {
        $('#messageModal').fadeOut();
    });

    $('#modal-submit').click(function() {
        alert("메시지 전송 완료!");
        $('#messageModal').fadeOut();
    });

    let targetButton = null;

    $('.status-btn').click(function() {
        // ✅ 이미 승인된 경우는 모달 안뜸
        if ($(this).hasClass('completed')) {
            return;
        }
        targetButton = $(this);
        $('#confirmModal').fadeIn();
    });

    $('#confirm-cancel').click(function() {
        $('#confirmModal').fadeOut();
    });

    $('#confirm-submit').click(function() {
        if (targetButton && !targetButton.hasClass('completed')) {
            targetButton.addClass('completed');
        }
        $('#confirmModal').fadeOut();
    });
});
</script>

</body>
</html>
