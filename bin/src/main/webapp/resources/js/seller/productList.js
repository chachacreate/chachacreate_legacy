$(document).ready(function () {
  updateSelectedCount();

  $("input[name='flagship']").change(function () {
    const count = $("input[name='flagship']:checked").length;

    if (count > 3) {
      alert("대표 상품은 3개까지 선택할 수 있습니다.");
      // 방금 체크한 거 해제 (this는 현재 변경된 체크박스)
      $(this).prop("checked", false);
    }

    updateSelectedCount();
  });

  $(".edit-button").click(function () {
    const storeUrl = window.location.pathname.split("/")[2];
    const selectedCount = $("input[name='flagship']:checked").length;

    if (selectedCount > 3) {
      alert("대표 상품은 3개까지 선택할 수 있습니다.");
      return;
    }

    const dtoList = [];

    $("input[name='flagship']").each(function () {
      const productId = $(this).data("id");
      const flagshipCheck = $(this).is(":checked") ? 1 : 0;
      dtoList.push({ productId: productId, flagshipCheck: flagshipCheck });
    });

    $.ajax({
      url: `${cpath}/${storeUrl}/seller/products`,
      type: "PUT",
      contentType: "application/json",
      data: JSON.stringify(dtoList),
      success: function (response) {
        alert(response.message);
        location.reload();
      },
      error: function (xhr) {
        if (xhr.responseJSON && xhr.responseJSON.message) {
          alert(xhr.responseJSON.message);
        } else {
          alert("대표 상품 수정 실패");
        }
      }
    });
  });

  function updateSelectedCount() {
    const count = $("input[name='flagship']:checked").length;
    $("#selectedFlagshipCount").text(`선택된 대표 상품: ${count}개`);
  }
  
  // 삭제 버튼 클릭 이벤트 (복수 삭제 가능하게 수정)
  $(".save-button").click(function () {
    const storeUrl = window.location.pathname.split("/")[2];

    // 체크된 삭제할 상품 id 배열 수집
    const deleteList = [];
    $("input[name='delete']:checked").each(function () {
      const productId = $(this).data("id");
      deleteList.push({ productId: productId });
    });

    if (deleteList.length === 0) {
      alert("삭제할 상품을 선택하세요.");
      return;
    }

    if (!confirm(`${deleteList.length}개 상품을 삭제하시겠습니까?`)) {
      return;
    }

    $.ajax({
      url: `${cpath}/${storeUrl}/seller/products`,
      type: "DELETE",
      contentType: "application/json",
      data: JSON.stringify(deleteList),
      success: function (response) {
        alert(response.message);
        // 삭제 성공 시 화면에서 해당 상품 행 제거
        deleteList.forEach(item => {
          $(`input[name='delete'][data-id='${item.productId}']`).closest("tr").remove();
        });
        // 선택된 삭제 개수 초기화 가능
      },
      error: function (xhr) {
        if (xhr.responseJSON && xhr.responseJSON.message) {
          alert(xhr.responseJSON.message);
        } else {
          alert("상품 삭제 실패");
        }
      }
    });
  });
  
  // 상품 행 클릭 시 상세 페이지 이동
  $(".product-row").click(function (e) {
    // 체크박스 클릭 등 특정 엘리먼트 클릭 시는 상세페이지 이동 막기
    if ($(e.target).is("input[type='checkbox']")) {
      return; // 체크박스 클릭은 상세페이지 이동 방지
    }

    const productId = $(this).data("product-id");
    const storeUrl = window.location.pathname.split("/")[2];
    const detailUrl = `${cpath}/${storeUrl}/seller/productdetail/${productId}`;

    window.location.href = detailUrl;
  });
});