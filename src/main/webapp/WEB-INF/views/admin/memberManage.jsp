<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 관리자 페이지 - 회원 관리</title>
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/authMain.css">
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/memberManage.css">
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
            <div class="member-box">
                <div class="member-header">
                    <h2>회원 관리</h2>
                    <div class="search-box">
                        <input type="text" placeholder="Search">
                    </div>
                </div>

                <div class="table-wrapper">
                    <table class="member-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>사용자구분</th>
                                <th>아이디(이메일)</th>
                                <th>비밀번호</th>
                                <th>이름</th>
                                <th>주소</th>
                                <th>전화번호</th>
                                <th>주민등록번호</th>
                                <th>입금계좌</th>
                                <th>이력</th>
                            </tr>
                        </thead>
                        <tbody>
<% for (int i = 1; i <= 30; i++) { 
    String userType = (i == 1) ? "구매자" : (i == 2 ? "판매자" : "개인판매자");
    String email = (i == 1) ? "naccount334@gmail.com" : (i == 2 ? "jennysky468@naver.com" : "cigsmicks235@korea.com");
    String password = (i == 1) ? "incheon123" : (i == 2 ? "jheel" : "mynameishe");
    String name = (i == 1) ? "인천현" : (i == 2 ? "이재희" : "천화철");
    String address = "새란시 새란구 길동 123-45 상세주소 예시 매우 긴 주소 예시입니다 추가 설명 계속 길게 있음";
    String phone = "010-1234-5678";
    String ssn = (i == 1) ? "970501-1234567" : "001212-3456789";
    String account = "123-4567-123456";
    String history = (i == 1) ? "이용제한 경고 3회" : "정상회원";
    boolean isReported = (i <= 3);
%>
<tr class="<%= isReported ? "reported-member " : "" %><%= i > 10 ? "extra-row" : "" %>" <%= i > 10 ? "style='display:none;'" : "" %>>
    <td><button class="detail-toggle-btn">▼</button></td>
    <td class="ellipsis"><%= userType %></td>
    <td class="ellipsis"><%= email %></td>
    <td class="ellipsis"><%= password %></td>
    <td class="ellipsis"><%= name %></td>
    <td class="ellipsis"><%= address.length() > 25 ? address.substring(0, 25) + "..." : address %></td>
    <td class="ellipsis"><%= phone %></td>
    <td class="ellipsis"><%= ssn %></td>
    <td class="ellipsis"><%= account %></td>
    <td class="ellipsis"><%= history %></td>
</tr>

<tr class="detail-row" style="display:none;">
<td></td>
    <td colspan="9" class="detail-content">
        <strong>전체 주소:</strong> <%= address %><br>
        <strong>이력 상세:</strong> 예시 상세 활동 로그, 정지 기록 등...
    </td>
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

<footer>&copy; 2025 뜨락상회</footer>
</div>

<!-- 메시지 모달 -->
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

<script>
$(document).ready(function() {
    $('.has-submenu > a').click(function() {
        $(this).next('.submenu').slideToggle(200);
    });

    $('#showMoreBtn').click(function() {
        $('.extra-row').fadeIn();
        $(this).hide();
    });

    $('.reported-member td').click(function(e) {
        if (!$(e.target).hasClass('detail-toggle-btn')) {
            $('#messageModal').fadeIn();
        }
    });

    $('#modal-cancel').click(function() {
        $('#messageModal').fadeOut();
    });

    $('#modal-submit').click(function() {
        alert("메시지 전송 완료!");
        $('#messageModal').fadeOut();
    });

    $('.detail-toggle-btn').click(function(e) {
        e.stopPropagation();
        var row = $(this).closest('tr').next('.detail-row');
        row.slideToggle();
    });
});
</script>

</body>
</html>
