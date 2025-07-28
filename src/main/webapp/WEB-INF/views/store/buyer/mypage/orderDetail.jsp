<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문 상세</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/buyer/mypage/orderDetail.css" />
  <script>
    const cpath = '${pageContext.request.contextPath}';
    const orderId = '${orderId}';
  </script>
</head>
<body>
  <%@include file="/common/header.jsp" %>
  <%@include file="/common/main_nav.jsp" %>

  <div class="order-detail-page">
    <div class="order-detail-layout">
      <section class="order-detail-content">

        <!-- 주문 정보 -->
        <div class="block-header">
          <h2 class="block-title">주문 정보</h2>
          <div class="block-divider"></div>
        </div>
        <div class="section-block">
          <div class="product-desc">2025-06-27</div>
          <p>주문번호 <strong>12345678</strong></p>
        </div>

        <!-- 주문 상품 -->
        <div class="block-header">
          <h2 class="block-title">주문 상품</h2>
          <div class="block-divider"></div>
        </div>
        <div class="section-block">
          <!-- JS로 동적 추가됨 -->
        </div>

        <!-- 배송지 정보 -->
        <div class="block-header">
          <h2 class="block-title">배송지 정보</h2>
          <div class="block-divider"></div>
        </div>
        <div class="section-block">
          <!-- JS로 동적 추가됨 -->
        </div>

        <!-- 결제 정보 -->
        <div class="block-header">
          <h2 class="block-title">결제 정보</h2>
          <div class="block-divider"></div>
        </div>
        <div class="section-block payment-summary">
          <!-- JS로 동적 추가됨 -->
        </div>

      </section>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/resources/js/store/buyer/mypage/orderDetail.js"></script>
</body>
</html>
