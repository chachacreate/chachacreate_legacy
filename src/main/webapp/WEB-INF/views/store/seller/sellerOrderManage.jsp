<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문/발송관리</title>
  <%@ include file="/common/header.jsp" %>
<%--   <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/authMain.css"> --%>
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/store/seller/sellerOrderManage.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(function () {
	  $('input[name="status"]').change(function () {
	    const selected = $(this).val();
	    const storeUrl = '${storeUrl}';
	    
	    const redirectUrl = selected === '전체' || selected === '' 
	      ? `${cpath}/\${storeUrl}/seller/management/order` 
	      : `${cpath}/\${storeUrl}/seller/management/order?status=\${selected}`;
	      
	    window.location.href = redirectUrl;
	  });
	  
	// 환불요청 상태인 셀만 클릭 이벤트 부여
	  $('td.status-label.환불요청').click(function () {
	    const orderId = $(this).data('order-id');
	    if (!orderId) return;

	    if (confirm("해당 주문의 환불을 처리하시겠습니까?")) {
	      $.ajax({
	        url: `${cpath}/${storeUrl}/seller/management/order`,
	        method: 'PUT',
	        contentType: 'application/json',
	        data: JSON.stringify({ orderId: orderId }),
	        success: function () {
	          alert("환불 처리가 완료되었습니다.");
	          location.reload();
	        },
	        error: function (xhr) {
	          alert("환불 처리 중 오류가 발생했습니다: " + (xhr.responseJSON?.message || xhr.statusText));
	        }
	      });
	    }
	  });
});
</script>
</head>
<body>
  <div class="content-wrapper">
    
    <!-- ✅ 왼쪽 여백 -->
    <div class="spacer" style="width: 240px;"></div>

    <!-- ✅ 사이드바 include -->
    <%@ include file="/common/store_seller_sidenav.jsp" %>

    <!-- ✅ 메인 콘텐츠 영역 -->
    <div class="main-area">
      <main class="content">
        <div class="content-inner">
          <div class="member-box">
            <div class="member-header">
              <h2>주문/발송관리</h2>
              <div class="search-box">
                <label>
                  <input type="radio" name="status" value="전체" ${empty selectedStatus ? 'checked' : ''}> 전체
                </label>
                <label>
                  <input type="radio" name="status" value="CONFIRM" ${selectedStatus == 'CONFIRM' ? 'checked' : ''}> 발송전
                </label>
                <label>
                  <input type="radio" name="status" value="REFUND" ${selectedStatus == 'REFUND' ? 'checked' : ''}> 환불요청
                </label>
                <label>
                  <input type="radio" name="status" value="REFUND_OK" ${selectedStatus == 'REFUND_OK' ? 'checked' : ''}> 환불완료
                </label>
                <label>
                  <input type="radio" name="status" value="ORDER_OK" ${selectedStatus == 'ORDER_OK' ? 'checked' : ''}> 주문완료
                </label>
              </div>
            </div>

            <div class="table-wrapper">
              <table class="member-table">
                <thead>
                  <tr>
                    <th>처리상태</th>
                    <th>주문번호</th>
                    <th>주문자명</th>
                    <th>배송지</th>
                    <th>주문일</th>
                    <th>주문상품</th>
                    <th>상품수량</th>
                    <th>금액</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="item" items="${orderList}" varStatus="vs">
                    <tr class="${vs.index >= 10 ? 'extra-row' : ''}" style="${vs.index >= 10 ? 'display:none;' : ''}" data-status="${item.orderStatus}">
                      <td class="status-label ${item.orderStatusLabel}" 
                          data-order-id="${item.orderId}" 
                          style="${item.orderStatusLabel == '환불요청' ? 'cursor:pointer;' : ''}">
                        ${item.orderStatusLabel}
                      </td>
                      <td>${item.orderId}</td>
                      <td>${item.orderName}</td>
                      <td class="ellipsis">
                        <c:choose>
                          <c:when test="${fn:length(item.addressFull) > 25}">
                            ${fn:substring(item.addressFull, 0, 25)}...
                            <button class="address-toggle-btn" data-index="${vs.index}">▼</button>
                          </c:when>
                          <c:otherwise>
                            ${item.addressFull}
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td><fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd" /></td>
                      <td>${item.productName}</td>
                      <td>${item.orderCnt}</td>
                      <td><fmt:formatNumber value="${item.orderPrice}" type="number" />원</td>
                    </tr>
                    <tr class="detail-row address-detail-${vs.index}" style="display:none;">
                      <td colspan="8" class="detail-content">
                        <strong>전체 배송지:</strong> ${item.addressFull}<br>
                        <strong>상품 상세:</strong> ${item.productName} - 수량 ${item.orderCnt}개, 가격 
                        <fmt:formatNumber value="${item.orderPrice}" type="number" />원
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <div class="more-button-box">
              <button id="showMoreBtn">▼ 전체 보기</button>
            </div>

          </div>
        </div>
      </main>
    </div>
  </div>


<script>
$(document).ready(function () {
  // 서브메뉴 토글
  $('.has-submenu > a').click(function () {
    $(this).next('.submenu').slideToggle(200);
  });

  // 전체보기 버튼
  $('#showMoreBtn').click(function () {
    const $this = $(this);
    if ($this.data('expanded')) {
      $('.extra-row').fadeOut();
      $this.text('▼ 전체 보기');
      $this.data('expanded', false);
    } else {
      $('.extra-row').fadeIn();
      $this.text('▲ 접기');
      $this.data('expanded', true);
    }
  });

  // 주소 토글
  $('.address-toggle-btn').click(function (e) {
    e.stopPropagation();
    const index = $(this).data('index');
    $('.address-detail-' + index).slideToggle();
  });

//상태별 필터
  $('input[name="status"]').change(function () {
    const selected = $(this).val(); // 선택된 라디오 값

    // 먼저 모든 행 숨김
    $('table.member-table tbody tr').hide();

    // 선택된 상태에 해당하는 행만 표시
    $('table.member-table tbody tr').each(function () {
      const $row = $(this);

      if ($row.hasClass('detail-row')) return;

      const status = $row.data('status');

      if (selected === "전체" || selected === status) {
        $row.show();

        // 연결된 detail-row도 보여줄 수 있도록 초기화
        const index = $row.find('.address-toggle-btn').data('index');
        $('.address-detail-' + index).hide();
      }
    });

    // extra-row도 다시 접은 상태로 초기화
    $('.extra-row').hide();
    $('#showMoreBtn').text('▼ 전체 보기').data('expanded', false);

    // 전체보기 버튼은 '전체'일 때만 보이도록
    if (selected === '전체') {
      $('#showMoreBtn').show();
    } else {
      $('#showMoreBtn').hide();
    }
  });

});
</script>

</body>
</html>