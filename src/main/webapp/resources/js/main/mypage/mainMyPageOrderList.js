$(function () {

	// 상품 이미지나 상품명을 클릭하면 상품 상세 페이지로 이동
	$(document).on('click', '.product-name, .product-img', function () {
	  const $row = $(this).closest('tr');
	  const productId = $row.data('product-id');
	  console.log('product-id:', $row.data('product-id'));
	  const storeUrl = $row.data('store-url') || 'main';
	
	  if (productId) {
	    window.location.href = `${cpath}/${storeUrl}/productdetail/${productId}`;
	  } else {
	    alert("상품 정보를 찾을 수 없습니다.");
	  }
	});

    function loadOrderList(cpath) {
        $.ajax({
            url: cpath + '/api/main/mypage/orders',
            method: 'GET',
            contentType: 'application/json',
            success: function (response) {
                if (response.status === 200) {
                    const data = response.data;

                    let hasShipping = false;
                    let hasCompleted = false;

                    data.forEach(order => {
                        const date = new Date(order.orderDate);
                        const formattedDate = date.toISOString().split('T')[0];
                        const statusText = order.deliveryStatus; // 배송 전, 배송 중, 배송 완료

                        const itemHtml = `
                            <tr data-product-id="${order.productId}" data-store-url="${order.storeUrl}" || 'main'>
                                <td>${formattedDate}</td>
                                <td class="product-img"><img src="${cpath}/resources/productImages/${order.pimgUrl}" alt="${order.productName}" class="order-img"></td>
                                <td class="product-name">${order.productName}</td>
                                <td>${order.orderCnt}</td>
                                <td>${order.orderPrice.toLocaleString()}원</td>
                                <td>
                                    <div class="delivery-status" style="font-weight: bold; margin-bottom: 5px;">${statusText}</div>
                                    <button class="btn-detail" onclick="location.href='${cpath}/main/mypage/orderdetail/${order.orderId}'">주문상세</button>
                                </td>
                            </tr>`;

                        if (order.deliveryStatus === '배송 전') {
                            $('.order-page .order-table').eq(0).find('tbody').append(itemHtml);
                            hasShipping = true;
                        } else {
                            $('.order-page .order-table').eq(1).find('tbody').append(itemHtml);
                            hasCompleted = true;
                        }
                    });

                    if (!hasShipping) {
                        $('.order-page .order-table').eq(0).find('tbody').append('<tr><td colspan="6">주문 내역이 없습니다.</td></tr>');
                    }
                    if (!hasCompleted) {
                        $('.order-page .order-table').eq(1).find('tbody').append('<tr><td colspan="6">주문 내역이 없습니다.</td></tr>');
                    }
                } else {
                    alert("주문 내역을 불러오는 데 실패했습니다.");
                }
            },
            error: function () {
                alert("서버 오류로 주문 내역을 불러오지 못했습니다.");
            }
        });
    }

loadOrderList(window.cpath);
});
