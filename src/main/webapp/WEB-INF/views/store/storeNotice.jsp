<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지 / 소식</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainNotice.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
	<%@ include file="/common/header.jsp"%>
  <!-- ✅ 네비게이션 -->
  <jsp:include page="/common/storeMain_nav.jsp" />

<!-- JSP에서 contextPath와 storeUrl을 JS 변수로 전달 -->
<script>
  const contextPath = '${not empty pageContext.servletContext.contextPath ? pageContext.servletContext.contextPath : "/legacy"}';
  const storeUrl = '${storeUrl}';
</script>

<!-- JS 파일 로딩 -->
<script src="${contextPath}/resources/js/store/storeNotice.js"></script>

</head>

<body>
  <%-- 
  <input type="hidden" id="cpath" value="${cpath}">
  <input type="hidden" id="storeUrl" value="${storeUrl}"> 
  --%>

<div class="wrapper">
  <main class="notice-container">
    <h2>공지사항</h2>

    <div class="search-box">
      <input type="text" id="notice-search-input" placeholder="조회할 제목을 입력하세요">
      <button class="search-btn">검색</button>
    </div>
    <table class="notice-table">
      <thead>
        <tr><th>No.</th><th>제목</th><th>등록날짜</th></tr>
      </thead>
      <tbody id="notice-body">
        <!-- JS로 내용 동적으로 삽입 -->
      </tbody>
    </table>

    <div class="pagination" id="pagination">
      <!-- JS로 페이지 번호 자동 생성 -->
    </div>
  </main>

    <!-- FOOTER -->
  <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>
</div>
</body>
</html>
