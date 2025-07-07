<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 판매자 스토어정보</title>
<%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/sellerInfo.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/auth/join/joinSeller.css">
</head>
<body>
<div class="content-wrapper">
   <%@ include file="/common/store_seller_sidenav.jsp" %>

  <div class="main-area">
    <div class="content-wrapper">

      <main class="content">
        <div class="content-inner">
		  <h2>나의 스토어 정보</h2>
		  
			<div class="store-info-wrapper">
			  <div class="profile-section">
			    <!-- 왼쪽: 스토어 이미지 및 이름 -->
			    <div class="profile-img">
			      <img src="${cpath}/resources/productImages/${logoImg}" alt="스토어 로고" style="height: 80px" />
			    </div>
			    <button type="button" class="div3">사진 수정</button>
			    <div class="store-name">${storeName}</div>
			  </div>
			 
			<div class="frame-1156">
	          <div class="frame-1079">
	            <div class="section-title-wrapper">
				  <div class="section-title">내 스토어 정보</div>
				  <div class="section-line"></div>
				</div>
	            <div class="frame-1150">
	              <div class="frame-1153">
	                <div class="iconamoon-store-thin">
	                  <iconify-icon icon="mdi:store" width="48" height="48"></iconify-icon>
	                </div>
	                <div class="div4">스토어 소개</div>
	              </div>
	              <div class="div5">
	                ${storeInfo.storeDetail}</div>
	              </div>
	            </div>
	          </div>
	          <div class="frame-1080">
	            <div class="section-title-wrapper">
				  <div class="section-title">판매자 정보</div>
				  <div class="section-line"></div>
				</div>
	            <div class="frame-11502">
	              <div class="frame-1153">
	                <iconify-icon icon="mdi:account" width="47" height="47" class="iconoir-user"></iconify-icon>
	                <div class="div4">이름</div>
	              </div>
	              <div class="div5">${storeInfo.memberName}</div>
	            </div>
	            <div class="frame-1152">
	              <div class="frame-1153">
	                 <iconify-icon icon="mdi:phone" width="40" height="40"></iconify-icon>
	                <div class="div4">연락처</div>
	              </div>
	              <div class="_010-3924-2137">${storeInfo.memberPhone}</div>
	            </div>
	            <div class="frame-11532">
	              <div class="frame-1153">
	                <div class="iconamoon-email-thin">
	                  <iconify-icon icon="mdi:email" width="40" height="40"></iconify-icon>
	                </div>
	                <div class="div4">이메일</div>
	              </div>
	              <div class="yoonjung-450-gmail-com">${storeInfo.memberEmail}</div>
	            </div>
	            
	            <!-- ✅ 나의 이력 등록 -->
			<section class="section-box">
				<div class="section-title">
					<span class="check">✔</span> 나의 이력 등록하기
				</div>
				<p class="section-desc">판매자님의 작품 사진을 등록해주세요.</p>

				<div class="career-wrapper">
					<div class="career-box">
						<div class="upload-placeholder">+</div><input type="file" id="fileInput" style="display: none;" />
						<textarea class="career-text" placeholder="이력 설명"></textarea>
						<div class="char-count">0/150</div>
					</div>
				</div>
			</section>
	          </div>
	          <div class="frame-1081">
	            <div class="section-title-wrapper">
				  <div class="section-title">계좌 정보</div>
				  <div class="section-line"></div>
				</div>
	            <!-- ✅ 계좌 등록 -->
			<section class="section-box">
				<p class="section-desc">판매수익금으로 입금 받을 계좌를 등록해주세요</p>

				<label for="account-owner">이름</label> <input type="text"
					id="account-owner" class="input-box" placeholder="로그인 사용자 이름" readonly value="${sessionScope.loginMember.memberName}"/> <label
					for="bank">은행을 선택해 주세요.</label> <select id="bankselect" class="input-box">
					<option value="">은행선택</option>
					<option value="004">국민은행</option>
					<option value="020">우리은행</option>
					<option value="088">신한은행</option>
					<option value="003">기업은행</option>
					<option value="023">SC제일은행</option>
					<option value="011">농협은행</option>
					<option value="005">외환은행</option>
					<option value="090">카카오뱅크</option>
					<option value="032">부산은행</option>
					<option value="071">우체국</option>
					<option value="031">대구은행</option>
					<option value="037">전북은행</option>
					<option value="035">제주은행</option>
					<option value="007">수협은행</option>
					<option value="027">씨티은행</option>
					<option value="039">경남은행</option>
				</select> <label for="account-number">계좌번호를 입력해 주세요.</label>
				<!-- 계좌번호 입력 안내 박스 -->
				<div class="account-warning-box">
					<div class="account-warning-title">
						<span class="check">✔</span> <strong>간편결제로 연결할 수 없는 계좌</strong>
					</div>
					<ul class="account-warning-list">
						<li>본인 명의가 아닌 계좌</li>
						<li>가상계좌/적금/펀드/정기예금 등의 계좌</li>
						<li>휴대폰 번호 등으로 만든 평생 계좌번호</li>
						<li>계좌에 문제가 있는 경우 (예: 지급정지 또는 해약된 경우)</li>
					</ul>
				</div>


				<div class="account-input">
					<input type="text" id="accountnum" class="input-box2"
						placeholder="-없이 계좌번호 입력" />
					<input type="text" id="accountname" class="input-box2" placeholder="예금주명" readonly>
					<button type="button" class="account-button" id="accountSubmit">계좌 등록하기</button>
				</div>
			</section>

			<div class="button-wrapper">
				<button type="button" class="btn-outline" onclick="history.back()">돌아가기</button>
				<button type="submit" class="btn-primary">등록하기</button>
			</div>
			  
			<div class="button-wrapper">
		      <button class="save-button">저장</button>
		    </div>
			</div>
		  </div>
		</div>
      </main>
    </div>
  </div>
</div>
</body>
</html>