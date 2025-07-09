<%@ page contentType="java; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href="${cpath}/resources/css/store/buyer/mypage/cart.css" />
</head>
<body>

<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<div class="cart-page">

  <!-- 메인 레이아웃 -->
  <div class="cart-layout">

      <!-- 왼쪽 사이드바 -->
     <jsp:include page="/common/main_mypage_sidenav.jsp" />


	<section class="page-content">
    <!-- 장바구니 목록 영역 -->
    <section class="cart-section">

      <!-- 현재 스토어 -->
      <div class="cart-block">
        <div class="block-header">
          <h2 class="block-title">현재 스토어 장바구니</h2>
          <div class="block-divider"></div>
        </div>

        <div class="cart-item">
          <input type="checkbox" class="item-checkbox" />
          <img class="item-image" src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
          <div class="item-details">
            <div class="store-name">000 스토어</div>
            <div class="product-name">상품명 1</div>
            <div class="product-description">상품설명 블라블라 예시어쩌구...</div>
            <div class="product-price">10,000원</div>
            <div class="quantity-controls">
              <button class="btn-decrease">-</button>
              <span class="quantity">1</span>
              <button class="btn-increase">+</button>
            </div>
          </div>
        </div>
      </div>

      <!-- 전체 스토어 -->
      <div class="cart-block">
        <div class="block-header">
          <h2 class="block-title">전체 스토어 장바구니</h2>
          <div class="block-divider"></div>
        </div>

        <!-- 반복 상품 -->
        <div class="cart-item">
          <input type="checkbox" class="item-checkbox" />
          <img class="item-image" src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
          <div class="item-details">
            <div class="store-name">000 스토어</div>
            <div class="product-name">상품명 2</div>
            <div class="product-description">상품설명 블라블라 예시어쩌구...</div>
            <div class="product-price">20,000원</div>
            <div class="quantity-controls">
              <button class="btn-decrease">-</button>
              <span class="quantity">2</span>
              <button class="btn-increase">+</button>
            </div>
          </div>
        </div>

        <div class="cart-item">
          <input type="checkbox" class="item-checkbox" />
          <img class="item-image" src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
          <div class="item-details">
            <div class="store-name">000 스토어</div>
            <div class="product-name">상품명 3</div>
            <div class="product-description">상품설명 블라블라 예시어쩌구...</div>
            <div class="product-price">9,000원</div>
            <div class="quantity-controls">
              <button class="btn-decrease">-</button>
              <span class="quantity">2</span>
              <button class="btn-increase">+</button>
            </div>
          </div>
        </div>
      </div>

    </section>

    <!-- 주문 요약 -->
    <aside class="order-summary">
      <h3>주문 예상 금액</h3>
      <div class="summary-count">선택 상품 (2)</div>

      <div class="summary-item">
        <span>상품 1</span>
        <span>10,000원</span>
      </div>
      <div class="summary-item">
        <span>상품 2</span>
        <span>20,000원</span>
      </div>
      <div class="summary-item">
        <span>상품 3</span>
        <span>9,000원</span>
      </div>
      <div class="summary-item">
        <span>배송비</span>
        <span>2,500원</span>
      </div>

      <hr/>
      <div class="summary-total">
        <span>총 금액</span>
        <span>41,500원</span>
      </div>

      <div class="checkout-wrapper">
  <button class="checkout-btn" onclick="location.href='<c:url value="/main/order"/>'">결제하기</button>
</div>
    </aside>
</section>
  </div>
</div>

</body>

</html>