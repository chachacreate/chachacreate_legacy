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
	          <div class="frame-1081">
	            <div class="section-title-wrapper">
				  <div class="section-title">계좌 정보</div>
				  <div class="section-line"></div>
				</div>
	            <div class="frame-11502">
	              <div class="frame-1153">
	                <iconify-icon icon="mdi:account" width="47" height="47" class="iconoir-user"></iconify-icon>
	                <div class="div4">예금주명</div>
	              </div>
	              <div class="div5">${storeInfo.memberName}</div>
	            </div>
	            <div class="frame-11522">
	              <div class="frame-1153">
	                <iconify-icon icon="mdi:bank" width="40" height="40"></iconify-icon>
	                <div class="div4">은행</div>
	              </div>
	              <div class="div6">${storeInfo.accountBank}</div>
	            </div>
	            <div class="frame-11533">
	              <div class="frame-1153">
	                <iconify-icon icon="mdi:wallet" width="40" height="40"></iconify-icon>
	                <div class="div4">계좌번호</div>
	              </div>
	              <div class="_1002-858-069-478">${storeInfo.account}</div>
	            </div>
	          </div>
			  
			<div class="button-wrapper">
			  <a href="${cpath}/${storeUrl}/seller/management/sellerupdate" class="edit-button">수정</a>
			  <a href="${cpath}/${storeUrl}/seller/close" class="close-button">폐업하기</a>
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