<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>스토어 소개</title>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      margin: 0;
      background-color: #f7f6f2;
      color: #333;
    }

    .content-wrapper {
      max-width: 900px;
      margin: 0 auto;
      padding: 60px 24px;
    }

    .store-logo {
      text-align: center;
      margin-bottom: 50px;
    }

    .store-logo img {
      display: block;
      margin: 0 auto;
      max-width:120px;
      max-height:120px;
      width:auto;
      height:auto;
      border-radius: 16px;
      object-fit:contain;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .info-section {
      background: #ffffff;
      border-radius: 16px;
      padding: 32px 24px;
      margin-bottom: 40px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
    }

    .section-title {
      font-size: 22px;
      font-weight: 700;
      color: #2a3e34;
      margin-bottom: 24px;
      border-left: 5px solid #8aad8a;
      padding-left: 12px;
    }

    .info-table {
      width: 100%;
      border-collapse: collapse;
    }

    .info-table td {
      padding: 14px 10px;
      vertical-align: top;
    }

    .info-label {
      font-weight: 600;
      color: #555;
      width: 140px;
      white-space: nowrap;
    }

    .info-content {
      font-weight: 400;
      color: #222;
      line-height: 1.6;
    }
  </style>
</head>
<body>

  <%-- ✅ 공통 헤더 및 네비게이션 --%>
  <jsp:include page="/common/header.jsp" />
  <jsp:include page="/common/storeMain_nav.jsp" />

  <div class="content-wrapper">

    <!-- 스토어 로고 출력 -->
	<div class="store-logo">
	  <img id="logoImg" src="${logoImg}" alt="스토어 로고" />
	</div>

    <!-- ✅ 판매자 정보 -->
    <div class="info-section">
      <div class="section-title">판매자 정보</div>
      <table class="info-table">
        <tr><td class="info-label">판매자</td><td class="info-content" id="memberName"></td></tr>
        <tr><td class="info-label">연락처</td><td class="info-content" id="memberPhone"></td></tr>
        <tr><td class="info-label">이메일</td><td class="info-content" id="memberEmail"></td></tr>
      </table>
    </div>

    <!-- ✅ 스토어 소개 -->
    <div class="info-section">
      <div class="section-title">스토어 소개</div>
      <table class="info-table">
        <tr><td class="info-label">스토어 소개</td><td class="info-content" id="storeDetail"></td></tr>
      </table>
    </div>

    <!-- ✅ 이력 -->
    <div class="info-section">
      <div class="section-title">이력</div>
      <table class="info-table">
        <tr><td class="info-label">이력</td><td class="info-content" id="history"></td></tr>
      </table>
    </div>

  </div>
  <script>
  $(function () {
	  $.ajax({
	    url: "${cpath}/legacy/${storeUrl}/info",
	    method: 'GET',
	    contentType: 'application/json',
	    success: function (data) {
	    	console.log(data);
	      const storeInfo = data.data.storeInfoList[0];
	      const sellerInfo = data.data.sellerInfoList[0];

	      $('#memberName').text(sellerInfo.sellerName || '정보 없음');
	      $('#memberPhone').text(sellerInfo.sellerPhone || '-');
	      $('#memberEmail').text(sellerInfo.sellerEmail || '-');
	      $('#storeDetail').text(storeInfo.storeDetail || '-');
	      $('#history').text(sellerInfo.sellerProfile || '-');
	    },
	    error: function () {
	      alert("스토어 정보를 불러오는 데 실패했습니다.");
	    }
	  });
	});
    
  </script>

</body>
</html>
