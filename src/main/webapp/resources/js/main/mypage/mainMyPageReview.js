$(function () {

	// 상품 이미지나 상품명을 클릭하면 상품 상세 페이지로 이동
	$(document).on('click', '.product-name, .product-img', function () {
	  const $row = $(this).closest('tr');
	  const productId = $row.data('product-id');
	  const storeUrl = $row.data('store-url') || 'main';
	
	  if (productId) {
	    window.location.href = `${cpath}/${storeUrl}/productdetail/${productId}`;
	  } else {
	    alert("상품 정보를 찾을 수 없습니다.");
	  }
	});
	
	// 리뷰 내용을 클릭하면 상품 상세 페이지 내 리뷰 섹션으로 이동
	$(document).on('click', '.review-text', function () {
	  const $row = $(this).closest('tr');
	  const productId = $row.data('product-id');
	  const storeUrl = $row.data('store-url') || 'main';
	
	  if (productId) {
	    window.location.href = `${cpath}/${storeUrl}/productdetail/${productId}#review`;
	  } else {
	    alert("상품 정보를 찾을 수 없습니다.");
	  }
	});


  $.ajax({
    url: cpath + "/api/main/mypage/reviewmemberById",
    method: "GET",
    dataType: "json",
    success: function (response) {
      if (response.status === 200) {
        const reviews = response.data;
        
        reviews.forEach(review => {
          const row = `
            <tr data-product-id="${review.productId}" data-store-url="${review.storeUrl || 'main'}">
              <td><img src="${cpath}/resources/productImages/${review.pimgUrl}" class="product-img" /></td>
              <td class="product-name">${review.productName}</td>
              <td>
                <div class="review-wrapper">
                  <span class="review-text">${review.reviewText}</span>
                  <button class="toggle-btn">더보기</button>
                </div>
              </td>
              <td>${review.reviewDate}</td>
              <td>${review.rating}</td> // DB 미등록
              <td>${review.likeCount}</td> // DB 미등록
            </tr>
          `;
          $(".review-table tbody").append(row);
        });

        // 더보기/접기 버튼 다시 바인딩
        $('.toggle-btn').off("click").on("click", function () {
          const $btn = $(this);
          const $text = $btn.siblings('.review-text');
          $text.toggleClass('expanded');
          $btn.text($text.hasClass('expanded') ? '접기' : '더보기');
        });

      } else {
        alert("리뷰 조회 실패: " + response.message);
      }
    },
    error: function () {
      alert("리뷰 데이터를 불러오는 데 실패했습니다.");
    }
  });
});
