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
      <div class="store-name" id="storeName">
      	<a id="storeNameLink" href="#">&nbsp;</a></div>
      <div class="product-title-row">
        <div class="product-title" id="productTitle">&nbsp;</div>
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
      <button class="buy-button" type="button" onclick="location.href='${cpath}/{storeUrl}/order'">결제하기</button>
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
	<div class="review-section">
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

  <script src="${cpath}/resources/js/store/productDetail.js"></script>
  <script src="${cpath}/resources/js/store/productDetailReview.js"></script>

</body>
</html>
