<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageReview.css">
</head>
<body>
  <div class="wrapper">

    <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

    <!-- 메인 콘텐츠 영역 -->
    <main class="main-area">
      <!-- 왼쪽 사이드바 -->
     <jsp:include page="/common/main_mypage_sidenav.jsp" />
	
  <!-- ⭐ 리뷰 테이블 영역 -->
  <section class="content-area">
    <h2>작성 리뷰 확인</h2>
    <table class="review-table">
      <thead>
        <tr>
          <th>상품사진</th>
          <th>상품명</th>
          <th>리뷰</th>
          <th>작성일</th>
          <th>평점</th>
          <th>좋아요 수</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><img src="${cpath}/resources/images/sample1.jpg" class="product-img" /></td>
          <td>상품명1</td>
          <td>
		  <div class="review-wrapper">
		    <span class="review-text">
		      리뷰 전체 내용이 여기 표시됩니다. 페이커 역시 합쳐진 팀에 잔류했다. 201dndkdkdkkdkdkdkdkdkkdkxpmtmxdydhdhdhdhdhdhdhhddhdlsajdfkjslakdfjkasljfklasjdkfjsdklfjsakljdfklasjdfklsajdkfjdaskldjfklsdjfklsajdklfjdkljfklj
		    </span>
		    <button class="toggle-btn">더보기</button>
		  </div>
		</td>
          <td>2025-06-18</td>
          <td>4.5</td>
          <td>2</td>
        </tr>
        <!-- 추가 row -->
      </tbody>
    </table>
  </section>
</main>

    <!-- 푸터 -->
    <footer class="site-footer">
      <div class="footer-inner">
        <p>© 2025 뜨락상회. All rights reserved.</p>
      </div>
    </footer>

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
