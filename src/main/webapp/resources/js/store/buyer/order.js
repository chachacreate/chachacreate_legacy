let totalPrice = 0;
let finalTotal = 0;
let productName = "";
let productCount = 1;
let products = [];
let newAddr = false;

$(document).ready(function () {
  // 기본배송지 체크박스 클릭 이벤트
  $('#addrCheck').on('click', function () {
    if ($(this).is(':checked')) {
      $.ajax({
        url: `${cpath}/legacy/main/mypage/order/addr`,
        type: 'GET',
        success: function (data) {
          if (data.status === 200) {
            const addr = data.data;
            $('#sample6_postcode').val(addr.postNum);
            $('#sample6_address').val(addr.addressRoad);
            $('#sample6_detailAddress').val(addr.addressDetail);
            $('#sample6_extraAddress').val(addr.addressExtra);
            $('#addrId').val(addr.addressId);
            $('#checkAddrVal').val("1");
            $('input[type=button][onclick="sample6_execDaumPostcode()"').prop('disabled', true);
          } else {
            alert("기본 배송지를 불러오지 못했습니다.");
          }
        },
        error: function () {
          alert("기본 배송지 불러오기 실패");
        }
      });
    } else {
      $('#sample6_postcode').val('');
      $('#sample6_address').val('');
      $('#sample6_detailAddress').val('');
      $('#sample6_extraAddress').val('');
      $('#addrId').val('');
      $('#checkAddrVal').val("0");
      $('input[type=button][onclick="sample6_execDaumPostcode()"').prop('disabled', false);
    }
  });

  // sessionStorage에 저장된 상품 정보 불러오기
  const orderItemsStr = sessionStorage.getItem("orderItems");
  if (!orderItemsStr) {
    alert("선택된 상품이 없습니다. 장바구니에서 다시 선택해주세요.");
    location.href = `${cpath}/main/cart`;
    return;
  }

  try {
    products = JSON.parse(orderItemsStr);
  } catch (e) {
    console.error("JSON 파싱 오류", e);
    return;
  }
  
  const isFromCart = products.some(p => p.cartId !== undefined && p.cartId !== null);

  const $container = $('#productContainer');
  const $summaryList = $('#summaryProductList');

  products.forEach(item => {
    if (productName === "") {
      productName = item.productName;
    } else {
      productCount += 1;
    }
    const productHtml = `
      <div class="product-item">
        <div class="product-box">
          <!-- cart에서 session으로 받아 오기 때문에 pimgUrl에 cpath부터 붙어 있음 -->
          <img class="product-image" src="${item.pimgUrl}" alt="상품 이미지" />
          <div class="product-info">
            <div class="store-name">${item.storeName}</div>
            <div class="product-name">
              <strong>${item.productName}</strong>
            </div>
            <div class="product-detail">${item.productDetail || ''}</div>
            <div class="quantity">수량: ${item.productCnt}개</div>
          </div>
          <div class="price-quantity-wrapper">
            <div class="price">${item.price.toLocaleString()} 원</div>
          </div>
        </div>
      </div>`;
    $container.append(productHtml);

    const itemTotal = item.price * item.productCnt;
    totalPrice += itemTotal;
    const summaryHtml = `
      <div class="summary-item">
        <span>${item.productName} × ${item.productCnt}</span>
        <span>${itemTotal.toLocaleString()} 원</span>
      </div>`;
    $summaryList.append(summaryHtml);
  });

  $summaryList.append(`
    <div class="summary-item">
      <span>배송비</span><span id="deliveryFee">0 원</span>
    </div>`);

  finalTotal = totalPrice;
  if (productCount > 0) {
    productName += " 외 " + productCount + "개의 상품";
  }

  $('#finalTotal').text(`${finalTotal.toLocaleString()} 원`);

  // 결제 버튼 클릭 시
  $('#pay-btn').click(function () {
    const detailAddress = $('#sample6_detailAddress').val().trim();
    if (detailAddress === "" || $('#sample6_postcode').val().trim() === "") {
      alert("주소를 입력해주세요.");
      $('#sample6_detailAddress').focus();
      return;
    }

    if (productCount > 1) {
      productName += " 외 " + productCount + "개의 상품";
    }

    IMP.init("imp85735807");
    IMP.request_pay({
      pg: 'html5_inicis',
      pay_method: 'card',
      merchant_uid: 'merchant_' + new Date().getTime(),
      name: productName,
      amount: parseInt(finalTotal),
      buyer_email: loginMember.memberEmail,
      buyer_name: loginMember.memberName,
    }, function (rsp) {
      if (rsp.success) {
        const orderInfo = {
          memberId: loginMember.memberId,
          orderDate: new Date().toISOString().slice(0, 10),
          orderName: $('#receiverName').val(),
          orderPhone: $('#receiverPhone').val(),
          addressId: $('#addrId').val() || null,
          cardId: null,
          orderStatus: "ORDER_OK"
        };

        const addr = {
          addressId: $('#addrId').val() || null,
          postNum: $('#sample6_postcode').val(),
          addressRoad: $('#sample6_address').val(),
          addressDetail: $('#sample6_detailAddress').val(),
          addressExtra: $('#sample6_extraAddress').val(),
          addressCheck: $('#checkAddrVal').val()
        };

        const detailList = products.map(item => ({
          orderId: null,
          productId: item.productId,
          orderCnt: item.productCnt,
          orderPrice: item.price * item.productCnt
        }));

        if ($('#checkAddrVal').val() === "1") newAddr = true;

        const orderRequestDTO = {
          orderInfo,
          addr,
          detailList,
          newAddr
        };

        $.ajax({
          type: "POST",
          url: `${cpath}/legacy/main/order`,
          contentType: "application/json",
          data: JSON.stringify(orderRequestDTO),
          success: function (response) {
            if (response.status === 201) {
              const orderid = parseInt(response.data);

              // 장바구니 상품일 경우에만 삭제 실행
              if (isFromCart) {
                const cartIds = products.map(p => p.cartId).filter(id => id);
                const deletePromises = cartIds.map(cartId =>
                  $.ajax({
                    url: `${cpath}/legacy/main/mypage/cart/delete/${cartId}`,
                    type: 'DELETE'
                  })
                );

                Promise.all(deletePromises)
                  .then(() => {
                    alert("주문이 완료되었습니다. 주문번호 : " + orderid);
                    sessionStorage.removeItem("orderItems");
                    location.href = `${cpath}/main/order/complete/${orderid}`;
                  })
                  .catch(() => {
                    alert("장바구니 일부 삭제 실패. 주문은 완료됨.");
                    location.href = `${cpath}/main/order/complete/${orderid}`;
                  });
              } else {
                // 단일상품 주문일 경우
                alert("주문이 완료되었습니다. 주문번호 : " + orderid);
                sessionStorage.removeItem("orderItems");
                location.href = `${cpath}/main/order/complete/${orderid}`;
              }
            }
          },
          error: function (xhr) {
            alert("서버 오류로 주문에 실패했습니다.");
            console.error(xhr.responseText);
          }
        });
      } else {
        alert('결제 실패: ' + rsp.error_msg);
      }
    });
  });
});

function updateValue() {
  const check = document.getElementById("addrCheck").checked;
  document.getElementById("checkAddrVal").value = check ? "1" : "0";
}

function sample6_execDaumPostcode() {
  new daum.Postcode({
    oncomplete: function (data) {
      let addr = '';
      let extraAddr = '';

      if (data.userSelectedType === 'R') {
        addr = data.roadAddress;
        if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
          extraAddr += data.bname;
        }
        if (data.buildingName !== '' && data.apartment === 'Y') {
          extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
        }
        if (extraAddr !== '') {
          extraAddr = ' (' + extraAddr + ')';
        }
        document.getElementById("sample6_extraAddress").value = extraAddr;
      } else {
        addr = data.jibunAddress;
        document.getElementById("sample6_extraAddress").value = '';
      }

      document.getElementById('sample6_postcode').value = data.zonecode;
      document.getElementById("sample6_address").value = addr;
      document.getElementById("sample6_detailAddress").focus();
    }
  }).open();
}