<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>나의 리뷰</title>
  <script>const cpath = '${cpath}';</script>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageReview.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="${cpath}/resources/js/main/mypage/mainMyPageReview.js"></script>
</head>
<body>
  <div class="wrapper">

    <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
 <!-- ✅ storeUrl 기반 동적 네비게이션 -->
    <c:choose>
      <c:when test="${empty storeUrl}">
        <jsp:include page="/common/main_nav.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="/common/storeMain_nav.jsp" />
      </c:otherwise>
    </c:choose>

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
		<!-- JS로 동적 추가 -->
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
  
</body>
</html>
