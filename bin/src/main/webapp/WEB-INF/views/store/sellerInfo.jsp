<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 정보</title>
<link rel="stylesheet"
	href="${cpath}/resources/css/store/sellerInfo.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	 <!-- ✅ 공통 헤더 -->
  <jsp:include page="/common/header.jsp" />
  <jsp:include page="/common/storeMain_nav.jsp" />

  <div class="seller-container">
    <!-- 👤 프로필 영역 -->
    <div class="profile-section">
      <img src="${cpath}/resources/images/illustration.png" alt="판매자 이미지" class="profile-img">
      <h2 class="profile-name">차차 판매자</h2>
      <p class="profile-desc">따뜻한 감성을 담은 수공예 작품을 만드는 차차 스토어의 대표입니다.</p>
    </div>

    <!-- 📞 기본 정보 -->
    <div class="info-card">
      <h3 class="section-title">기본 정보</h3>
      <div class="info-row"><span class="label">📱 연락처</span><span class="value">010-1234-1234</span></div>
      <div class="info-row"><span class="label">📧 이메일</span><span class="value">aaaa1234@naver.com</span></div>
    </div>

    <!-- 🛍️ 스토어 소개 -->
    <div class="info-card">
      <h3 class="section-title">스토어 소개</h3>
      <p class="desc-box">차차 스토어는 수공예 제품만을 정성스럽게 선별하여 판매하는 공간입니다. 고객과의 진심 어린 소통을 통해 더 나은 제품과 서비스를 제공하고자 노력합니다.</p>
    </div>

    <!-- 🏆 이력 -->
    <div class="info-card">
      <h3 class="section-title">나의 이력</h3>
      <ul class="history-list">
        <li>2019 - 수공예 창업</li>
        <li>2020 - 오프라인 플리마켓 10회 이상 참가</li>
        <li>2021 - SNS 팔로워 1만 돌파</li>
        <li>2022 - 차차 스토어 론칭</li>
        <li>2023 - 공방 오픈</li>
      </ul>
    </div>
  </div>
	</div>

	<script>
		$(document).ready(
				function() {
					const storeUrl = '${storeUrl}'; // URL 경로에서 storeUrl 전달됨
					$.ajax({
						url : '/create/api/' + storeUrl + '/info',
						method : 'GET',
						success : function(res) {
							
							const store = res.data.storeInfoList[0];
							const seller = res.data.sellerInfoList[0];
							
							$('#storeName').text(store.storeName);
							$('#storeDetail').text(store.storeDetail);
							$('#sellerName').text(seller.sellerName);
							$('#sellerPhone').text(seller.sellerPhone);
							$('#sellerEmail').text(seller.sellerEmail);
							$('#sellerProfile').append(
									'<li>' + seller.sellerProfile + '</li>');
							$('#logoImg').attr('src', '${cpath}/resources/images/' + store.logoImg);
						},
						error : function(err) {
							console.error("판매자 정보 불러오기 실패:", err);
						}
					});
				});
	</script>

</body>
</html>
