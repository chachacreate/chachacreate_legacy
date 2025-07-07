$(document).ready(function () {
  $.ajax({
    url: `${cpath}/api/main/mypage/orderdetail/${orderId}`,
    method: 'GET',
    success: function (res) {
      if (res.status === 200) {
        const data = res.data;

        // 주문 날짜 & 번호
        const orderDate = new Date(data.orderDate).toLocaleDateString();
        $('.section-block').eq(0).find('.product-desc').text(orderDate);
        $('.section-block').eq(0).find('p strong').text(data.orderId);

        // 배송지 정보
        $('.section-block').eq(2).html(`
          <p><strong>${data.orderName}</strong></p>
          <div class="product-desc">${data.orderPhone}</div>
          <p>${data.addressRoad} ${data.addressDetail} ${data.addressExtra}</p>
        `);

        // 결제 정보
        $('.payment-summary').html(`
          <div class="payment-total">
            <span>총 결제 금액</span>
            <span>${data.totalAmount.toLocaleString()} 원</span>
          </div>
          <div class="payment-detail">
            <span class="label">상품 금액</span>
            <span class="value">${data.totalAmount.toLocaleString()} 원</span>
          </div>
          <div class="payment-detail">
            <span class="label">배송비</span>
            <span class="value">0 원</span>
          </div>
          <hr class="payment-divider"/>
          <div class="payment-detail">
            <span class="label">카드 결제</span>
            <span class="value">${data.totalAmount.toLocaleString()} 원</span>
          </div>
          <div class="payment-note">
            ${data.cardCompany ? data.cardCompany : ''} ${data.maskedCardNum ? '(' + data.maskedCardNum + ')' : ''}
          </div>
        `);

        // 주문 상품 목록
        const $productList = $('.section-block').eq(1);
        $productList.empty();

        data.orderItems.forEach(item => {
          const productItemHtml = `
            <div class="product-item">
              <div class="product-box">
                <img src="${cpath}/resources/images/${item.pimgUrl}" class="product-image" />
                <div class="product-info">
                  <div class="store-name">${item.storeName}</div>
                  <div class="product-name">${item.productName}</div>
                  <div class="product-desc">${item.productDetail}</div>
                  <div class="product-price">₩ ${item.orderPrice.toLocaleString()}</div>
                </div>
                <div class="review-wrapper">
                  ${data.canWriteReview ? `<button class="review-button" onclick="location.href='${cpath}/main/productdetail/${item.productId}#review'">리뷰 쓰기</button>` : ''}
                </div>
              </div>
            </div>
          `;
          $productList.append(productItemHtml);
        });
      } else {
        alert("주문 정보를 불러오지 못했습니다.");
      }
    },
    error: function () {
      alert("서버 오류로 인해 주문 정보를 불러올 수 없습니다.");
    }
  });
});
