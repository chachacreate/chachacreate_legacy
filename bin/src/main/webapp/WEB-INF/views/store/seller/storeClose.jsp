<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 스토어폐업</title>
<%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/storeClose.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body>
<div class="wrapper">
  <header>
    <div class="header-inner">
      <div class="login-bar">
        <span>수제대추고님 반갑습니다.</span>
        <button class="logout-btn">로그아웃</button>
      </div>
    </div>
  </header>

  <div class="main-area">
    <div class="content-wrapper">
      <nav class="sidebar">
        <div class="profile-section" role="button" tabindex="0" aria-label="스토어관리 페이지로 이동">
          <img src="${cpath}/resources/images/_11.png" class="profile-img" />
          <div class="store-name">수제대추고</div>
        </div>
        <ul class="menu-list">
          <li><a href="#"><span class="menu-text">상품등록</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">판매상품관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">주문/발송확인(취소/환불)</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">환불관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">정산관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">문의메시지</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">리뷰관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">스토어관리</span><span class="arrow">></span></a></li>
        </ul>
        <div class="sidebar-footer">
          <button class="btn-go-buyer">구매자페이지 이동</button>
        </div>
      </nav>

      <main class="content">
        <div class="content-inner">
		  <h2>스토어 폐업 신청</h2>
		
		  <div class="frame-1171">
		    <div class="icon-system-warning">
			  <iconify-icon icon="ic:round-warning" style="color: #FF4D4F; font-size: 80px;"></iconify-icon>
			</div>
		    <div class="div16">정말로 폐업하시겠습니까?</div>
		    <div class="div17">
		      <div class="frame-758">
		        <div class="frame-757">
		          <div class="frame-754">
		            <input type="text" class="input-field" placeholder="이메일" />
		          </div>
		          <div class="frame-754">
		            <input type="password" class="input-field" placeholder="비밀번호" />
		          </div>
		        </div>
		      </div>
		    </div>
		    <div class="frame-752">
		      <div class="component-3">
		        <button class="close-btn">폐업하기</button>
		      </div>
		    </div>
		  </div>
		</div>
      </main>
    </div>
  </div>
  <footer>&copy; 2025 뜨락상회</footer>
</div>
</body>
</html>