$(function () {
  const cpath = $(".cart-page").data("cpath");
  const memberId = window.loggedInMemberId || null;
  const apiUrl = `${cpath}/api/main/mypage/cart`;

  // 현재 URL에서 storeUrl 추출
  function getCurrentStoreUrlFromPath() {
    const pathSegments = window.location.pathname.split("/");
    const storeUrl = pathSegments[2];

    // storeUrl이 "main"이어도 null로 처리(개인 판매자 고려)
    return (storeUrl === "main" || !storeUrl) ? null : storeUrl;
  }

  // 이미지 경로 처리
  function getImageUrl(imgPath) {
    if (!imgPath) return "";
    if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
      return imgPath;
    }
    if (imgPath.includes("resources/productImages")) {
      return `${cpath}/${imgPath}`;
    }
    return `${cpath}/resources/productImages/${imgPath}`;
  }

  // 개인 판매자의 경우 storeUrl이 없기 때문에
  // null이 뜨더라도 main과 같다고 인식하는 로직 필요
  function normalizeStoreUrl(url) {
    return (!url || url === "main" || url === "/" || url === "") ? "main" : url;
  }

  // 장바구니 데이터 가져오기(storeUrl 비교 처리 포함)
  $.ajax({
    url: apiUrl,
    method: "GET",
    dataType: "json"
  })
    .done(function (data) {
      const items = data.data;
      const currentStoreUrl = getCurrentStoreUrlFromPath();

      // storeUrl 포함된 item들에 isCurrentStore 계산 후 렌더링
      const processedItems = items.map(function (item) {
        const currentStore = normalizeStoreUrl(currentStoreUrl);
        const itemStore = normalizeStoreUrl(item.storeUrl);
        const isCurrentStore = currentStore === itemStore;

        return Object.assign({}, item, { isCurrentStore });
      });

      renderCart(processedItems);
    })
    .fail(function (err) {
      console.error("장바구니 불러오기 실패", err);
    });

  function renderCart(items) {
    const $currentStoreSection = $("#current-store-cart");
    const $allStoreSection = $("#all-store-cart");

    if (!items.length) {
      $currentStoreSection.html("<p>현재 스토어 장바구니에 담긴 상품이 없습니다.</p>");
      $allStoreSection.html("<p>전체 스토어 장바구니에 담긴 상품이 없습니다.</p>");
      updateSummary([]);
      return;
    }

    const currentStoreItems = items.filter(item => item.isCurrentStore);
    const allStoreItems = items.filter(item => !item.isCurrentStore);

    $currentStoreSection.html(
      currentStoreItems.length
        ? currentStoreItems.map(createCartItemHtml).join("")
        : "<p>현재 스토어 장바구니에 담긴 상품이 없습니다.</p>"
    );

    $allStoreSection.html(
      allStoreItems.length
        ? allStoreItems.map(createCartItemHtml).join("")
        : "<p>전체 스토어 장바구니에 담긴 상품이 없습니다.</p>"
    );

    attachQuantityEvents();
    attachCheckboxEvents();
    updateSummary(items);
  }

  function createCartItemHtml(item) {
    const imgUrl = getImageUrl(item.pimgUrl);
    // 스토어 이름 null일 경우 뜨락상회(메인)
    const storeName = item.storeName || "뜨락상회";
    return `
      <div class="cart-item" data-cart-id="${item.cartId}" data-stock="${item.stock}" data-store-id="${item.storeId}" data-store-url="${item.storeUrl}" data-product-id="${item.productId}">
        <input type="checkbox" class="item-checkbox" />
        <img class="item-image" src="${imgUrl}" alt="상품 이미지" />
        <div class="item-details">
          <div class="store-name">${storeName}</div>
          <div class="product-name">${item.productName}</div>
          <div class="product-description">${item.productDetail}</div>
          <div class="product-price">${item.price.toLocaleString()}원</div>
          <div class="quantity-controls">
            <button class="quantity-btn minus">-</button>
            <span class="quantity">${item.productCnt}</span>
            <button class="quantity-btn plus">+</button>
          </div>
        </div>
      </div>
    `;
  }

  // 상품 페이지에서와 달리 DB에 값이 저장되어야 하므로 함수로 관리
  function attachQuantityEvents() {
    $(".cart-item").each(function () {
      const $item = $(this);
      const cartId = $item.data("cart-id");
      const stock = parseInt($item.data("stock"), 10);
      const $quantitySpan = $item.find(".quantity");
      const $minusBtn = $item.find(".quantity-btn.minus");
      const $plusBtn = $item.find(".quantity-btn.plus");

      $minusBtn.off("click").on("click", function () {
        let quantity = parseInt($quantitySpan.text(), 10);
        if (quantity > 1) {
          quantity--;
          $quantitySpan.text(quantity);
          updateQuantity(cartId, quantity);
        }
      });

      $plusBtn.off("click").on("click", function () {
        let quantity = parseInt($quantitySpan.text(), 10);
        if (quantity < stock) {
          quantity++;
          $quantitySpan.text(quantity);
          updateQuantity(cartId, quantity);
        } else {
          alert("재고보다 더 많이 담을 수 없습니다.");
        }
      });
    });
  }

  function attachCheckboxEvents() {
    const $selectAll = $("#select-all");

    if ($selectAll.length) {
      $selectAll.off("change").on("change", function () {
        const checked = this.checked;
        $(".item-checkbox").prop("checked", checked);
        updateSummary();
      });
    }

    $(".item-checkbox").off("change").on("change", updateSummary);

    const $deleteBtn = $(".delete-button");
    const $deleteAllBtn = $(".delete-all-button");

    if ($deleteBtn.length) {
      $deleteBtn.off("click").on("click", deleteSelectedItems);
    }
    if ($deleteAllBtn.length) {
      $deleteAllBtn.off("click").on("click", deleteAllItems);
    }
  }

  function updateQuantity(cartId, newQuantity) {
    $.ajax({
      url: apiUrl,
      method: "PUT",
      contentType: "application/json",
      data: JSON.stringify({ cartId, productCnt: newQuantity }),
      dataType: "json"
    })
      .done(function () {
        updateSummary();
      })
      .fail(function (err) {
        console.error("수량 변경 실패", err);
      });
  }

  function updateSummary() {
    const $checkedItems = $(".item-checkbox:checked");
    const $summary = $("#order-summary");

    if ($checkedItems.length === 0) {
      $summary.html("<p>선택된 상품이 없습니다.</p>");
      return;
    }

    let total = 0;
    let html = `<h3>주문 예상 금액</h3><div class="summary-count">선택 상품 (${ $checkedItems.length })</div>`;

    $checkedItems.each(function () {
      const $item = $(this).closest(".cart-item");
      const name = $item.find(".product-name").text();
      const priceText = $item.find(".product-price").text();
      const price = parseInt(priceText.replace(/,/g, '').replace('원', ''), 10);
      const quantity = parseInt($item.find(".quantity").text(), 10);
      const itemTotal = price * quantity;

      html += `<div class="summary-item"><span>${name}</span><span>${itemTotal.toLocaleString()}원</span></div>`;
      total += itemTotal;
    });

    html += `<div class="summary-item"><span>배송비</span><span>0원</span></div><hr/>`;
    html += `<div class="summary-total"><span>총 금액</span><span>${total.toLocaleString()}원</span></div>`;
    html += `
      <div class="checkout-wrapper">
        <button class="checkout-btn">결제하기</button>
      </div>
    `;

    $summary.html(html);
  }

  function deleteSelectedItems() {
    const $checkedItems = $(".item-checkbox:checked");
    if ($checkedItems.length === 0) {
      alert("선택된 상품이 없습니다.");
      return;
    }
    if (!confirm("선택한 상품을 삭제하시겠습니까?")) return;

    const promises = [];
    $checkedItems.each(function () {
      const cartId = $(this).closest(".cart-item").data("cart-id");
      promises.push($.ajax({
        url: `${apiUrl}/delete/${cartId}`,
        method: "DELETE"
      }));
    });

    $.when.apply($, promises).done(function () {
      location.reload();
    });
  }

  function deleteAllItems() {
    if (!confirm("장바구니 전체 비우시겠습니까?")) return;
    $.ajax({
      url: `${apiUrl}/deleteAll`,
      method: "DELETE",
      data: { memberId: memberId }
    }).done(function () {
      location.reload();
    });
  }

  // 상품명, 이미지 클릭 시 해당 상품 상세 페이지 이동
  $(document).on('click', '.product-name, .item-image', function () {
    const $item = $(this).closest('.cart-item');
    const productId = $item.data('product-id');
    const storeUrl = $item.data('store-url') || 'main';
    window.location.href = `${cpath}/${storeUrl}/productdetail/${productId}`;
  });

  // 스토어 이름 클릭 시 해당 스토어 페이지 이동
  $(document).on('click', '.store-name', function () {
    const $item = $(this).closest('.cart-item');
    const storeUrl = $item.data('store-url') || 'main';
    window.location.href = `${cpath}/${storeUrl}`;
  });



// 장바구니에서 선택된 상품 정보를 세션에 저장하여 order로 보내기
$(document).on("click", ".checkout-btn", function () {
  const $checkedItems = $(".item-checkbox:checked");

  if ($checkedItems.length === 0) {
    alert("선택된 상품이 없습니다.");
    return;
  }

  const items = [];
  $checkedItems.each(function () {
    const $item = $(this).closest(".cart-item");

    
    items.push({
      cartId: $item.data("cart-id"),
      productId: $item.data("product-id"),
      productName: $item.find(".product-name").text(),
      storeName: $item.find(".store-name").text(),
      productCnt: parseInt($item.find(".quantity").text(), 10),
      price: parseInt($item.find(".product-price").text().replace(/[^0-9]/g, ''), 10),
      pimgUrl: $item.find(".item-image").attr("src")
    });
  });

  // sessionStorage에 저장
  sessionStorage.setItem("orderItems", JSON.stringify(items));
  console.log("items:", items);

  window.location.href = `${cpath}/main/order`;
});

});
