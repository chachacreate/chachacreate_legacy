<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>주문 내역</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageOrderList.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>window.cpath = '${cpath}';</script>
  <script src="${cpath}/resources/js/main/mypage/mainMyPageOrderList.js"></script>
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

	<section class="order-page">
  <!-- 배송중인 주문내역 -->
  <h2>배송중인 주문내역</h2>
  <table class="order-table">
    <thead>
      <tr>
        <th>주문일</th>
        <th>상품사진</th>
        <th>상품명</th>
        <th>수량</th>
        <th>가격</th>
        <th>주문 상세</th>
      </tr>
    </thead>
    <tbody>
      <!-- 반복 가능 -->
    </tbody>
  </table>

  <!-- 마이 주문내역 -->
  <h2>마이 주문 내역</h2>
  <table class="order-table">
    <thead>
      <tr>
        <th>주문일</th>
        <th>상품사진</th>
        <th>상품명</th>
        <th>수량</th>
        <th>가격</th>
        <th>주문 상세</th>
      </tr>
    </thead>
    <tbody>
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
