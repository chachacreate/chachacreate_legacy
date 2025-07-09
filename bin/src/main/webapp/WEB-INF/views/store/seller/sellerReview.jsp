<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageReview.css">
</head>
<body>
  <div class="wrapper">
    <!-- 헤더 -->
    <header>
      <div class="header-inner">
        <div class="login-bar">
          <span>관리자님 반갑습니다.</span>
          <button class="logout-btn">로그아웃</button>
        </div>
      </div>
    </header>
    <!-- 내비게이션 -->
    <nav class="site-nav">
      <div class="nav-inner">
        <div class="nav-logo">뜨락상회</div>
        <ul class="nav-menu">
          <li><a href="#">홈</a></li>
          <li><a href="#">스토어</a></li>
          <li><a href="#">이벤트</a></li>
          <li><a href="#">고객센터</a></li>
        </ul>
      </div>
    </nav>
    <!-- 메인 콘텐츠 영역 -->
    <main class="main-area">
      <aside class="sidebar">
        <ul>
          <li><a href="#">대시보드</a></li>
          <li><a href="#">내 정보</a></li>
          <li><a href="#">판매 관리</a></li>
          <li><a href="#">정산 내역</a></li>
        </ul>
      </aside>
	
  <!-- :별: 리뷰 테이블 영역 -->
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
          <td><img src="resources/images/sample1.jpg" class="product-img" /></td>
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