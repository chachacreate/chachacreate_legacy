<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>판매자페이지 리뷰관리</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageReview.css">
</head>
<body>
<div class="content-wrapper">
      <%@ include file="/common/store_seller_sidenav.jsp" %>

  <div class="main-area">

      <main class="content">
        <div class="content-inner">
         <!-- :별: 리뷰 테이블 영역 -->
    <h2>작성 리뷰 확인</h2>
    <table class="review-table">
      <thead>
        <tr>
          <th>리뷰작성일</th>
          <th>대표이미지</th>
          <th>상품이름</th>
          <th>작성자</th>
          <th>리뷰내용</th>
          <th>상품등록일</th>
        </tr>
      </thead>
      <tbody>
	  <c:forEach var="item" items="${reviewList}">
	    <tr>
	      <td>${item.reviewDate}</td>
	      <td><img src="${cpath}/resources/productImages/${item.pimgUrl}" class="product-img" alt="상품이미지" /></td>
	      <td>${item.productName}</td>
	      <td>${item.memberName}</td>
	      <td>
	        <div class="review-wrapper">
	          <span class="review-text">${item.reviewText}</span>
	          <button class="toggle-btn">더보기</button>
	        </div>
	      </td>
	      <td><fmt:formatDate value="${item.productDate}" pattern="yyyy-MM-dd"/></td>
	    </tr>
	  </c:forEach>
	</tbody>
    </table>
        </div>
      </main>
    </div>
  </div>
</div>
  <!-- 스크립트 -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function () {
  $('.toggle-btn').on('click', function () {
    const $btn = $(this);
    const $text = $btn.siblings('.review-text');
    $text.toggleClass('expanded');
    if ($text.hasClass('expanded')) {
      $btn.text('접기');
    } else {
      $btn.text('더보기');
    }
  });
});
</script>
</body>
</html>