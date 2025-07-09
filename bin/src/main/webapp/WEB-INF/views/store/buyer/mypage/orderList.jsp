<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/buyer/mypage/orderList.css" />
</head>
<body>
<%@include file="/common/header.jsp" %>
	<%@include file="/common/main_nav.jsp" %>
<div class="order-history-page">
  <div class="order-history-layout">

        <!-- 사이드 메뉴 -->
    <aside class="sidebar-menu">
      <div class="menu-item">
        <span>마이정보수정</span>
        <span class="arrow">&gt;</span>
      </div>
      <div class="menu-item ">
        <span>장바구니</span>
        <span class="arrow">&gt;</span>
      </div>
      <div class="menu-item selected">
        <span>주문내역</span>
        <span class="arrow">&gt;</span>
      </div>
      <div class="menu-item">
        <span>관심사 선택</span>
        <span class="arrow">&gt;</span>
      </div>
      <div class="menu-item">
        <span>작성 리뷰 확인</span>
        <span class="arrow">&gt;</span>
      </div>
    </aside>

    <!-- 주문 내역 컨텐츠 -->
    <section class="order-list-section">

	<!-- 배송중인 주문내역 -->
	<div class="block-header">
	    <h2 class="block-title">배송중인 주문내역</h2>
	    <div class="block-divider"></div>
	  </div>
	<div class="order-block">
	
	  <!-- 컬럼 제목 행 -->
	  <div class="order-item order-item-header">
	    <div class="order-date">주문일</div>
	    <div class="order-item-image">상품사진</div>
	    <div class="order-item-details">
	      <div class="order-product-info-header">상품정보</div>
	      <div class="order-qty-header">수량</div>
	      <div class="order-price-header">가격</div>
	      <div class="order-footer-header">배송 상태</div>
	    </div>
	  </div>
	</div>
	
	<!-- 완료된 주문내역 -->
	<div class="block-header">
	    <h2 class="block-title">마이 주문 내역</h2>
	    <div class="block-divider"></div>
	  </div>
	<div class="order-block">
	
	  <!-- 컬럼 제목 행 -->
	  <div class="order-item order-item-header">
	    <div class="order-date">주문일</div>
	    <div class="order-item-image">상품사진</div>
	    <div class="order-item-details">
	      <div class="order-product-info-header">상품정보</div>
	      <div class="order-qty-header">수량</div>
	      <div class="order-price-header">가격</div>
	      <div class="order-footer-header">배송 상태</div>
	    </div>
	  </div>
	</div>


    </section>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function () {
    $.ajax({
        url: '${cpath}/api/main/mypage/orders',
        method: 'GET',
        contentType: 'application/json',
        success: function (response) {
            if (response.status === 200) {
                const data = response.data;

                data.forEach(order => {
                    const date = new Date(order.orderDate);
                    const formattedDate = date.toISOString().split('T')[0]; // yyyy-mm-dd

                    const itemHtml = `
                    <div class="order-item">
                        <div class="order-date">\${formattedDate}</div>
                        <img class="order-item-image" src="${cpath}/resources/images/\${order.pimgUrl}" alt="상품 이미지" />
                        <div class="order-item-details">
                            <div class="order-product-info">
                                <div class="order-store-name">\${order.storeName}</div>
                                <div class="order-product-name">\${order.productName}</div>
                                <div class="order-product-desc">\${order.productDetail}</div>
                            </div>
                            <div class="order-qty">
                                <span class="order-qty">\${order.orderCnt}</span>
                            </div>
                            <div class="order-price">
                                <span class="order-price">\${order.orderPrice.toLocaleString()}원</span>
                            </div>
                            <div class="order-footer">
                                <div class="order-status">\${order.deliveryStatus}</div>
                                <button class="btn-detail" onclick="location.href='${cpath}/main/mypage/orderdetail/\${order.orderId}'">주문상세</button>
                            </div>
                        </div>
                    </div>`;

                    // 배송 상태 분류
                    if (order.deliveryStatus === '배송 전') {
                        $('.order-list-section .order-block').eq(0).append(itemHtml); // 첫 번째 order-block (배송중인)
                    } else {
                        $('.order-list-section .order-block').eq(1).append(itemHtml); // 두 번째 order-block (완료된)
                    }
                });
            } else {
                alert("주문 내역을 불러오는 데 실패했습니다.");
            }
        },
        error: function () {
            alert("서버 오류로 주문 내역을 불러오지 못했습니다.");
        }
    });
});
</script>

</body>
</html>