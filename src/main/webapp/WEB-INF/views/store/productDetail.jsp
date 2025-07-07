<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>상품 상세 페이지</title>
  <%@ include file="/common/header.jsp" %>
  
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="${cpath}/resources/css/store/productDetail.css">
</head>
<body data-cpath="${cpath}">
<script>
  window.loggedInMemberId = ${loginMember != null ? loginMember.memberId : 'null'};
</script>
<!-- ✅ storeUrl 기반 동적 네비게이션 -->
    <c:choose>
      <c:when test="${empty storeUrl}">
        <jsp:include page="/common/main_nav.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="/common/storeMain_nav.jsp" />
      </c:otherwise>
    </c:choose>
<div class="div">

  <!-- 상품 상세 섹션 -->
  <div class="product-section">
    <!-- 왼쪽: 이미지 -->
    <div class="media-gallery">
      <div class="main-image">
        <img src="" alt="메인 이미지" />
      </div>
      <div class="thumbnail-row" id="thumbnailRow">
        <img src="" alt="썸네일1" class="thumbnail" />
        <img src="" alt="썸네일2" class="thumbnail" />
        <img src="" alt="썸네일3" class="thumbnail" />
      </div>
    </div>

    <!-- 오른쪽: 정보 -->
    <div class="product-details">
    <div class="first-row">
    <div class="store-title-row">
      <div class="store-name" id="storeName">
      	<a id="storeNameLink" href="#">&nbsp;</a></div>
      	<button class="report-btn" id="reportBtn" type="button">신고</button>
      	</div>
	  <div class="edit-button-row">
	    <button class="edit-button" id="editProductBtn" type="button" style="display:none">수정</button>
	  </div>
	  </div>
      <div class="product-title-row">
        <div class="product-title" id="productName">&nbsp;</div>
        <button class="like-button">❤️</button>
      </div>
      <div class="product-category">
      	  <div id="productTypeCategory" class="badge">&nbsp;</div>
	      <div id="productUCategory" class="badge">&nbsp;</div>
	      <div id="productDCategory" class="badge">&nbsp;</div>
      </div>
      <div class="product-quantity">
        <label class="quantity-label">수량</label>
        <div class="quantity-control">
          <button class="quantity-btn minus">-</button>
          <div class="quantity-display">1</div>
          <button class="quantity-btn plus">+</button>
        </div>
        <div class="product-price" id="productPrice">&nbsp;</div>
      </div>
      <div class="action-buttons">
        <button class="cart-button" type="button" >장바구니 담기</button>
      <button class="buy-button" type="button" >결제하기</button>
      </div>
    </div>
  </div>

  <!-- 구분선 및 상세 설명 -->
  <div class="detail-text-img">
  <h1>상품 디테일</h1>
    <div class="img-ex">
      <img class="detail-img1" src="" />
      <img class="detail-img2" src=""/>
    </div>
    <div class="detail-text">
      <span>
        <span class="detail-text-middle">&nbsp;</span>
        <span class="detail-text-small">&nbsp;</span>
      </span>
    </div>
  </div>
  
  <!-- 리뷰 섹션 -->
	<div id="review" class="review-section">
	  <h2>리뷰</h2>
	
	  <!-- 리뷰 작성 폼 -->
	  <div class="review-form">
	    <textarea id="review-input" class="review-input" placeholder="리뷰를 입력하세요!!"></textarea>
	    <button id="review-submit-btn" class="review-submit-btn">등록</button>
	  </div>
	
	  <!-- 리뷰 목록 -->
	  <div class="review-list"></div>
	  <div class="no-review-message" style="display: none; color: #888;">해당 상품에는 리뷰가 없습니다.</div>
	</div>

  
</div>

	<!-- 신고 모달창 -->
	<div id="reportModal" class="modal-overlay" style="display:none;">
	  <div class="modal-content">
	    <h3 id="reportModalTitle">판매자 신고하기</h3>
	    <input type="text" id="reportTitle" placeholder="신고 제목을 입력하세요" class="report-input" />
	    <textarea id="reportText" placeholder="신고 사유를 입력하세요" class="report-textarea"></textarea>
	    <div class="modal-buttons">
	      <button id="submitReport">신고하기</button>
	      <button id="cancelReport">취소</button>
	    </div>
	  </div>
	</div>
	
	<!-- 리뷰 신고 모달창 -->
	<div id="reportModal2" class="modal-overlay" style="display:none;">
	  <div class="modal-content">
	    <h3 id="reportModalTitle2">리뷰 신고하기</h3>
	    <input type="text" id="reportTitle2" placeholder="신고 제목을 입력하세요" class="report-input" />
	    <textarea id="reportText2" placeholder="신고 사유를 입력하세요" class="report-textarea"></textarea>
	    <div class="modal-buttons">
	      <button id="submitReport2">신고하기</button>
	      <button id="cancelReport2">취소</button>
	    </div>
	  </div>
	</div>


  <script src="${cpath}/resources/js/store/productDetail.js"></script>
  <script src="${cpath}/resources/js/store/productDetailReview.js"></script>

</body>
</html>
