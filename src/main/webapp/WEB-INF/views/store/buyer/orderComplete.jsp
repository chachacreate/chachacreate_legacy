<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>결제 완료</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/buyer/orderComplete.css" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
  <div class="order-complete-container">
    <!-- <img class="complete-icon" src="/resources/images/kakao.png" alt="완료 아이콘" /> --><!-- 이거 이상있어서 제외했어 -->
    <div class="complete-message">주문이 완료되었습니다</div>
    <div class="order-number">주문번호: <span id="orderId">-</span></div>

    <div class="order-section">
      <div class="section-header">
        <h2>주문 상품</h2>
        <button class="section-more">&gt;</button>
      </div>

      <div class="order-grid order-header">
        <div></div> <!-- 이미지 -->
        <div>상품명</div>
        <div>수량</div>
        <div>가격</div>
      </div>
      <!-- 주문 상품 아이템은 JS로 추가됨 -->
    </div>

    <div class="horizontal-sections">
      <div class="info-box">
        <div class="info-box-title">배송지 정보</div>
        <div class="info-row">
          <span class="info-label">이름</span>
          <span class="info-value" id="orderName"></span>
        </div>
        <div class="info-row">
          <span class="info-label">전화번호</span>
          <span class="info-value" id="orderPhone"></span>
        </div>
        <div class="info-row">
          <span class="info-label">주소</span>
          <span class="info-value" id="fullAddress"></span>
        </div>
      </div>

      <div class="info-box">
        <div class="info-box-title">결제 정보</div>
        <div class="info-row">
          <span class="info-label">상품 금액</span>
          <span class="info-value" id="itemTotal"></span>
        </div>
        <div class="info-row">
          <span class="info-label">배송비</span>
          <span class="info-value">0 원</span>
        </div>
        <div class="info-row">
          <span class="info-label">총 결제</span>
          <span class="info-value" id="paymentTotal"></span>
        </div>
      </div>
    </div>

	<div class="button-group">
	  <button onclick="window.location='${pageContext.request.contextPath}/main'">홈으로 돌아가기</button>
	  <button onclick="window.location='${pageContext.request.contextPath}/main/mypage/orders'">주문내역으로 돌아가기</button>
	</div>
	

 </div>

  <script>
    $(document).ready(function () {
    	
    	const pathParts = window.location.pathname.split('/');
    	const orderId = pathParts[pathParts.length - 1]; // 마지막 부분이 orderId
    	
    	// > 버튼 누르면 주문 상세로
    	$('.section-more').on('click', function() {
    	    window.location.href = `${pageContext.request.contextPath}/main/mypage/orderdetail/\${orderId}`;
    	  });

      $.ajax({
        url: `${pageContext.request.contextPath}/legacy/main/mypage/orderdetail/\${orderId}`,
        type: 'GET',
        contentType: 'application/json',
        success: function (res) {
          if (res.status === 200) {
            const data = res.data;
            // 주문번호
            $('#orderId').text(data.orderId);

            // 주문자 정보
            $('#orderName').text(data.orderName);
            $('#orderPhone').text(data.orderPhone);

            // 주소 한 줄 조합을 위한 정보
			const parts = [
			    data.postNum || '',
			    data.addressRoad || '',
			    data.addressDetail || '',
			    data.addressExtra || ''
			];
			
			// 공백 제거 + null/false 무시
			const fullAddress = parts.filter(part => part && part.toString().trim() !== '').join(' ');
			$('#fullAddress').text(fullAddress);

            // 총 결제 금액
            $('#itemTotal').text(`\${data.totalAmount} 원`);
            $('#paymentTotal').text(`\${data.totalAmount}원 카드 결제`);

            // 기존 아이템 제거
            $('.order-section .order-item').remove();

            // 주문 상품 목록 렌더링
            data.orderItems.forEach(item => {
              const itemTotal = (item.orderPrice * item.orderCnt);

              const $item = $(`
                <div class="order-grid order-item" data-product-id="\${item.productId}" data-store-url="\${item.storeUrl}">
                  <img src="${item.pimgUrl}" alt="상품 이미지" class="product-image" />
                  <div class="productName">\${item.productName}</div>
                  <div class="orderCnt">\${item.orderCnt}</div>
                  <div class="orderPrice">\${itemTotal} 원</div>
                </div>
              `);
              $('.order-section').append($item);
            });
            
            // 상품명, 이미지 클릭 시 해당 상품 상세 페이지 이동
            $(document).on('click', '.productName, .product-image', function () {
              const $item = $(this).closest('.order-item');
              const productId = $item.data('product-id');
              const storeUrl = $item.data('store-url') || 'main';
              window.location.href = `${pageContext.request.contextPath}/\${storeUrl}/products/\${productId}`;
            });

          } else {
            alert('주문 상세 정보를 불러오는 데 실패했습니다.');
          }
        },
        error: function () {
          alert('서버 요청 실패');
        }
      });
    });
  </script>
</body>
</html>