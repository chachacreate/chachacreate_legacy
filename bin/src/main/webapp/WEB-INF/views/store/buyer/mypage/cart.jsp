<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <link rel="stylesheet" href="${cpath}/resources/css/store/buyer/mypage/cart.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="${cpath}/resources/js/store/buyer/mypage/cart.js" defer></script>
</head>
<body>
<script>
  window.loggedInMemberId = ${loginMember != null ? loginMember.memberId : 'null'};
</script>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<div class="cart-page" data-cpath="${cpath}">
  <div class="cart-layout">

    <!-- 왼쪽 사이드바 -->
    <jsp:include page="/common/main_mypage_sidenav.jsp" />

    <section class="page-content">

      <!-- 장바구니 목록 영역 -->
      <section class="cart-section">
	  <div class="cart-block">
	  <div class="head-control">
	  	<div class="select-all-wrapper">
	      <input type="checkbox" id="select-all" class="select-all"/>
	      <label for="select-all">전체 선택</label>
	    </div>
	    <div>
	      <button class="delete-button" type="button">삭제</button>
	      <button class="delete-all-button" type="button">비우기</button>
	    </div>
	    </div>
	    <div class="block-header">
	      <h2 class="block-title">현재 스토어 장바구니</h2>
	      <div class="block-divider"></div>
	    </div>
	    <div id="current-store-cart">
	      <!-- JS에서 현재 스토어 장바구니 아이템 렌더링 -->
	    </div>
	  </div>
	
	  <div class="cart-block">
	    <div class="block-header">
	      <h2 class="block-title">전체 스토어 장바구니</h2>
	      <div class="block-divider"></div>
	    </div>
	    <div id="all-store-cart">
	      <!-- JS에서 전체 스토어 장바구니 아이템 렌더링 -->
	    </div>
	  </div>
	</section>


      <!-- 주문 요약 -->
      <aside class="order-summary" id="order-summary">
        <!-- JS에서 동적으로 요약 렌더링 -->
      </aside>

    </section>
  </div>
</div>

</body>
</html>