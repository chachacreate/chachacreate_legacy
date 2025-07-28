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
	          </div>
	          
	          <!-- ✅ 계좌 등록 정보 -->
<div class="frame-1081">
  <div class="section-title-wrapper">
    <div class="section-title">계좌 정보</div>
    <div class="section-line"></div>
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:account" width="40" height="40"></iconify-icon>
      <div class="div4">이름</div>
    </div>
    <input type="text" id="account-owner" class="info-input" readonly value="${sessionScope.loginMember.memberName}" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:bank" width="40" height="40"></iconify-icon>
      <div class="div4">은행</div>
    </div>
    <select id="bankselect" class="info-input">
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
    </select>
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:wallet" width="40" height="40"></iconify-icon>
      <div class="div4">계좌번호</div>
    </div>
    <input type="text" id="accountnum" class="info-input" placeholder="-없이 계좌번호 입력" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:badge-account" width="40" height="40"></iconify-icon>
      <div class="div4">예금주명</div>
    </div>
    <input type="text" id="accountname" class="info-input" readonly />
  </div>

  <div class="button-wrapper">
    <button type="button" class="btn-outline" onclick="history.back()">돌아가기</button>
    <button type="submit" class="btn-primary">등록하기</button>
  </div>
</div>

<!-- ✅ 나의 이력 등록 -->
<div class="frame-1081">
  <div class="section-title-wrapper">
    <div class="section-title">나의 이력 등록</div>
    <div class="section-line"></div>
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:image" width="40" height="40"></iconify-icon>
      <div class="div4">작품 사진</div>
    </div>
    <input type="file" id="fileInput" class="info-input" />
  </div>

  <div class="frame-11522">
    <div class="frame-1153">
      <iconify-icon icon="mdi:text-box" width="40" height="40"></iconify-icon>
      <div class="div4">이력 설명</div>
    </div>
    <textarea class="info-textarea" placeholder="이력 설명 (최대 150자)" maxlength="150"></textarea>
  </div>
</div>
	          <div class="button-wrapper">
  <a href="${cpath}/${storeUrl}/seller/management/sellerupdate" class="edit-button">수정</a>
  <a href="${cpath}/${storeUrl}/seller/close" class="close-button">폐업하기</a>
</div>
	         
		  </div>
		</div>
      </main>
    </div>
  </div>
</div>
</body>
</html>