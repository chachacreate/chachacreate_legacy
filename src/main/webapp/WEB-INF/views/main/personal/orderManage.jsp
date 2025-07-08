<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인판매 물품 주문관리</title>
<link rel="stylesheet"
	href="${cpath}/resources/css/main/personal/orderManage.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>
<body>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<main class="order-container">
<jsp:include page="/common/main_personal_subnav.jsp" />

<div class="swiper-button-next"></div>
<div class="swiper-button-prev"></div>

<div class="swiper-container-wrapper">
  <div class="swiper mySwiper">
    <div class="swiper-wrapper">

    </div>
  </div>
</div>

</main>

 <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>

	<script>
		  // 날짜 포맷 함수
		  function formatDate(timestamp) {
		    const date = new Date(timestamp);
		    const year = date.getFullYear();
		    const month = ('0' + (date.getMonth() + 1)).slice(-2);
		    const day = ('0' + date.getDate()).slice(-2);
		    return `${year}-${month}-${day}`;
		  }

		  // 주소 25자 이상일 경우 줄임 처리 & 펼침 버튼 생성
		  function truncateAddress(address, index) {
		    if (address.length > 25) {
		      return `
		        ${address.substring(0, 25)}...
		        <button class="address-toggle-btn" data-index="f${index}">&#9660;</button>
		      `;
		    }
		    return address;
		  }

		  const initialStatus = "주문완료";

		  function buildRow(order, index) {
		    const {
		      orderStatus: status,
		      orderDate,
		      orderId,
		      orderName,
		      addressRoad,
		      addressDetail,
		      addressExtra,
		      orderCnt,
		      orderPrice,
		      productName
		    } = order;

		    const statusClass = status;
		    const orderDateStr = formatDate(orderDate);
		    const orderNum = String(orderId).padStart(8, '0');
		    const fullAddress = `${addressRoad} ${addressDetail} ${addressExtra}`.trim();
		    const shortAddress = truncateAddress(fullAddress, index);
		    const quantity = orderCnt;
		    const price = orderPrice.toLocaleString();

		    let manageBtn = '';
		    switch (status) {
		      case "주문완료":
		        manageBtn = `<button class="confirm-btn">확인</button>`;
		        break;
		      case "발송전":
		        manageBtn = `<button class="ship-btn">발송하기</button>`;
		        break;
		      case "환불요청":
		        manageBtn = `<button class="refund-btn">환불완료처리</button>`;
		        break;
		    }

		    const mainRow = `
		      <tr data-status="${status}" data-index="\${index}">
		        <td class="status-label \${statusClass}">\${status}</td>
		        <td>\${orderDateStr}</td>
		        <td>\${orderNum}</td>
		        <td>\${orderName}</td>
		        <td class="ellipsis">\${shortAddress}</td>
		        <td>\${quantity}</td>
		        <td>\${price}</td>
		        <td>\${manageBtn}</td>
		      </tr>
		    `;

		    const detailRow = `
		      <tr class="detail-row address-detail-\${index}" style="display:none;" data-status="\${status}">
		        <td colspan="9" class="detail-content">
		          <strong>전체 배송지:</strong> \${fullAddress}<br>
		          <strong>상품 상세:</strong> \${productName} - 수량 \${quantity}개, 가격 \${price}원
		        </td>
		      </tr>
		    `;

		    return mainRow + detailRow;
		  }

		  function createSlide(productName, productId, orders) {
			  const rows = orders.map((order, index) => buildRow(order, index)).join('');

			  return `
			    <div class="swiper-slide" data-product-id="\${productId}">
			      <div class="slide-content-vertical">
			        <div class="product-info-box">
			          <h3>상품 정보</h3>
			          <div class="product-detail">
			            <img src="resources/images/product_sample.png" alt="상품 이미지" class="product-img">
			            <div class="product-desc">
			              <p>상품명: \${productName}</p>
			              <p>설명: \${productName}에 대한 설명입니다.</p>
			            </div>
			          </div>
			        </div>

			        <div class="order-bottom-wrapper">
			          <div class="order-filter-bar" data-product-id="\${productId}">
			            \${['주문완료', '발송전', '환불요청', '환불완료'].map(status => `
			              <button class="order-filter-btn\${status === initialStatus ? ' active' : ''}" 
			                      data-status="\${status}" 
			                      data-product-id="\${productId}">
			                \${status} <span class="count" data-type="\${status}">0</span>건
			              </button>
			            `).join('')}
			          </div>

			          <div class="order-section">
			            <h3>주문 내역</h3>
			            <table class="order-table">
			              <thead>
			                <tr>
			                  <th>처리상태</th>
			                  <th>주문일</th>
			                  <th>주문번호</th>
			                  <th>주문자명</th>
			                  <th>배송지</th>
			                  <th>상품 수량</th>
			                  <th>금액</th>
			                  <th>관리</th>
			                </tr>
			              </thead>
			              <tbody id="filter-order-body-\${productId}">
			                \${rows}
			              </tbody>
			            </table>
			          </div>
			        </div>
			      </div>
			    </div>
			  `;
			}

		  function showLoadError(productId) {
			  $(`#filter-order-body-${productId}`).html('<tr><td colspan="9">주문 내역을 불러오지 못했습니다.</td></tr>');
			}


		  function applyFilter(status, productId) {
			  const $slide = $(`.swiper-slide[data-product-id="${productId}"]`);
			  const $tbody = $slide.find(`#filter-order-body-\${productId}`);

			  $slide.find('.order-filter-btn').removeClass('active')
			    .filter(`[data-status="${status}"]`).addClass('active');

			  $tbody.find('tr').each(function () {
			    const $row = $(this);
			    const rowStatus = $row.data('status');
			    const isDetail = $row.hasClass('detail-row');
			    const prevRowStatus = $row.prev().data('status');
			    const match = rowStatus === status || (isDetail && prevRowStatus === status);
			    $row.toggle(match);
			  });
			}

			function updateOrderCount(productId) {
			  const $tbody = $(`#filter-order-body-${productId}`);
			  const counts = { 주문완료: 0, 발송전: 0, 환불요청: 0, 환불완료: 0 };

			  $tbody.find('tr').each(function () {
			    const $row = $(this);
			    if (!$row.hasClass('detail-row')) {
			      const status = $row.data('status');
			      if (counts.hasOwnProperty(status)) counts[status]++;
			    }
			  });

			  $(`.order-filter-bar[data-product-id="${productId}"] .count`).each(function () {
			    const type = $(this).data('type');
			    $(this).text(counts[type] || 0);
			  });
			}



			function registerEvents() {
				  // 필터 버튼 클릭 시
				  $(document).on('click', '.order-filter-btn', function () {
				    const status = $(this).data('status');
				    const productId = $(this).data('product-id');
				    applyFilter(status, productId);
				  });

				  // 확인 / 환불 버튼 클릭 시 처리
				  $(document).on('click', '.confirm-btn, .refund-btn, .cancel-btn', function () {
				    const $row = $(this).closest('tr');
				    const $tbody = $row.closest('tbody');
				    const tbodyId = $tbody.attr('id'); // e.g., filter-order-body-123
				    const productId = tbodyId.split('filter-order-body-')[1];

				    const $clone = $row.clone(true);
				    const $statusCell = $clone.find('.status-label');
				    const $btnCell = $clone.find('td').last();

				    if ($(this).hasClass('confirm-btn')) {
				      $statusCell.text('발송전').attr('class', 'status-label 발송전');
				      $btnCell.html('<button class="ship-btn">발송하기</button>');
				    } else if ($(this).hasClass('refund-btn')) {
				      $statusCell.text('환불완료').attr('class', 'status-label 환불완료');
				      $btnCell.empty();
				    }

				    $row.remove();
				    const $detailRow = $row.next();
				    if ($detailRow.hasClass('detail-row')) $detailRow.remove();

				    updateOrderCount(productId);
				  });

				  $(document).on('click', '#order-history-body .ship-btn', function () {
					  const $row = $(this).closest('tr');
					  $row.find('.status-label').text('완료').attr('class', 'status-label 완료');
					  $(this).remove();
					  updateOrderCount();
					});

				}


		    $(document).on('click', '#order-history-body .ship-btn', function () {
		      const $row = $(this).closest('tr');
		      $row.find('.status-label').text('완료').attr('class', 'status-label 완료');
		      $(this).remove();
		      updateOrderCount();
		    });

			  function loadOrders() {
				  $.ajax({
				    url: `${cpath}/api/main/sell/order/management`,
				    method: 'GET',
				    contentType: 'application/json',
				    success: function (response) {
				      if (response.status !== 200) {
				        showLoadError(productId);
				        return;
				      }

				      const orders = response.data;
				      const productMap = new Map();

				      orders.forEach(order => {
				        if (!productMap.has(order.productId)) {
				          productMap.set(order.productId, { productName: order.productName, orders: [] });
				        }
				        productMap.get(order.productId).orders.push(order);
				      });

				      const $wrapper = $('.swiper-wrapper');
				      $wrapper.empty();

				      productMap.forEach((data, productId) => {
				        $wrapper.append(createSlide(data.productName, productId, data.orders));
				      });

				      if (window.swiperInstance) window.swiperInstance.destroy(true, true);
				      window.swiperInstance = new Swiper('.mySwiper', { slidesPerView: 1, spaceBetween: 30 });

				      productMap.forEach((_, productId) => {
				        applyFilter(initialStatus, productId);
				        updateOrderCount(productId);
				      });
				  }
				});
			  }
			  
		  $(document).ready(function () {
		    registerEvents();
		    loadOrders();
		  });
   
	/* --------------스와이프 JS------------- */
	const swiper = new Swiper('.mySwiper', {
	  slidesPerView: 1,
	  spaceBetween: 30,
	  loop: true,
	  navigation: {
	    nextEl: '.swiper-button-next',
	    prevEl: '.swiper-button-prev',
	  },
	});
	
	$(document).ready(function () {
	  $('.address-toggle-btn').on('click', function () {
	    const index = $(this).data('index');
	    $('.address-detail-' + index).slideToggle();
	  });
	});
	</script>
</body>
</html>
