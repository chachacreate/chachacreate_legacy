<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문/결제</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/buyer/order.css" />
  <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>const cpath = "${pageContext.request.contextPath}";</script>
  <script src="${pageContext.request.contextPath}/resources/js/store/buyer/order.js"></script>
<script>
  window.loginMember = {
    memberId: "${loginMember.memberId}",
    memberName: "${loginMember.memberName}",
    memberEmail: "${loginMember.memberEmail}"
  };
</script>

</head>
<body>
<%@include file="/common/header.jsp" %>
<%@include file="/common/main_nav.jsp" %>
<div class="order-page">
  <div class="order-layout">
    <%@ include file="/common/main_mypage_sidenav.jsp" %>

    <!-- 좌측: 배송지 + 주문상품 -->
    <section class="order-left">
      <!-- 배송지 -->
      <div class="block-header">
        <h2 class="block-title">배송지</h2>
        <div class="block-divider"></div>
      </div>
      <div class="order-block delivery-block">
        <div class="delivery-info">
          <div class="delivery-row">
            <label for="receiverName">이름</label>
            <input type="text" id="receiverName" name="receiverName" value="${sessionScope.loginMember.memberName}" />
          </div>
          <div class="delivery-row">
            <label for="receiverPhone">연락처</label>
            <input type="text" id="receiverPhone" name="receiverPhone" value="${sessionScope.loginMember.memberPhone}" />
          </div>
          <div class="delivery-row postcode-row">
            <label for="sample6_postcode">우편번호</label>
            <input type="text" id="sample6_postcode" name="postcode" placeholder="우편번호" readonly />
            <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" />
            <input type="checkbox" id="addrCheck" onclick="updateValue()"><label>기본배송지 체크</label><input type="hidden" name="checkAddrVal" id="checkAddrVal" value="0">
            <input type="hidden" id="addrId" value="">
          </div>
          <div class="delivery-row">
            <label for="sample6_address">주소</label>
            <input type="text" id="sample6_address" name="address" placeholder="주소" readonly />
          </div>
          <div class="delivery-row">
            <label for="sample6_detailAddress">상세주소</label>
            <input type="text" id="sample6_detailAddress" name="detailAddress" placeholder="상세주소" />
          </div>
          <div class="delivery-row">
            <label for="sample6_extraAddress">참고항목</label>
            <input type="text" id="sample6_extraAddress" name="extraAddress" placeholder="참고항목" readonly />
          </div>
        </div>
      </div>

      <!-- 주문 상품 -->
      <div class="block-header">
        <h2 class="block-title">주문 상품</h2>
        <div class="block-divider"></div>
      </div>
      <div class="order-block product-block" id="productContainer"></div>
    </section>

    <!-- 우측: 결제 요약 -->
    <aside class="order-summary">
      <div class="summary-title">결제 예상 금액</div>
      <div id="summaryProductList" class="summary-list"></div>
      <div class="summary-total">
        <span>총 결제 금액</span><span class="total-price" id="finalTotal">0 원</span>
      </div>
      <button class="pay-button" id="pay-btn">결제하기</button>
    </aside>
  </div>
</div>
</body>
</html>
