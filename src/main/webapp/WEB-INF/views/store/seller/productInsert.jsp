<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>뜨락상회 판매자 상품등록</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/productInsert.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <script src="${cpath}/resources/js/seller/productInsert.js"></script>
</head>

<body>
  <div class="page-container">
    <div class="left-padding"></div>
    <%@ include file="/common/store_seller_sidenav.jsp" %>
    <div class="content-wrapper">
      <main class="content">
        <div class="content-inner">
          <div class="frame-1075">
            <div class="top-bar">
              <h2>상품 등록</h2>
              <div class="top-action">
                <button id="addProductBtn" class="icon-button2" type="button">
                  <iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon>
                </button>
              </div>
            </div>
            <!-- action 속성 추가로 기본 submit 방지 -->
            <form method="post" enctype="multipart/form-data" action="javascript:void(0)">
              <div id="productFormsContainer">
                <div class="product-form-unit">
                  <div class="form-body-row">
                    <div class="frame-1076">
                      <label for="file-upload-1" class="frame-817-btn" aria-label="추가 버튼">
                        <iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon>
                      </label>
                      <input id="file-upload-1" name="imageFiles" type="file" accept="image/*" style="display:none;" />
                      <div class="frame-1077">
                        <label for="file-upload-2" class="frame-8152-btn">
                          <div class="frame-8152"><iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon></div>
                        </label>
                        <input id="file-upload-2" name="imageFiles" type="file" accept="image/*" style="display:none;" />
                        <label for="file-upload-3" class="frame-8152-btn">
                          <div class="frame-8152"><iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon></div>
                        </label>
                        <input id="file-upload-3" name="imageFiles" type="file" accept="image/*" style="display:none;" />
                      </div>
                      <div class="frame-1078">
                        <button class="icon-button" type="button">
                          <iconify-icon icon="mdi:menu" class="icon-menu"></iconify-icon>
                        </button>
                        <button class="icon-button" type="button">
                          <iconify-icon icon="mdi:menu" class="icon-menu"></iconify-icon>
                        </button>
                      </div>
                    </div>
                    <div class="frame-1196">
                      <div class="frame-1079">
                        <button type="button" class="remove-product-btn">삭제</button>
                        <div class="text-area">
                          <div class="div17">상품 이름</div>
                          <input type="text" name="productName" class="box2" required />
                        </div>
                        <div class="text-input">
                          <div class="div17">상품 가격</div>
                          <input type="number" name="price" class="box2" min="0" required />
                        </div>
                        <div class="text-area2">
                          <div class="div17">상품 설명</div>
                          <textarea name="description" class="box" required></textarea>
                        </div>
                        <div class="group-90">
                          <div class="div20">상품 카테고리</div>
                          <div class="frame-10772">
                            <div class="frame-8153">
                              <select name="typeCategoryId" class="category-select" required>
                                <option selected disabled>대분류 선택</option>
                                <c:forEach var="t" items="${typeCategories}">
                                  <option value="${t.id}">${t.name}</option>
                                </c:forEach>
                              </select>
                            </div>
                            <div class="frame-816">
                              <select name="category2" class="category-select uCategory" required>
                                <option selected disabled>중분류 선택</option>
                                <c:forEach var="u" items="${uCategories}">
                                  <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                              </select>
                            </div>
                            <div class="frame-8172">
                              <select name="dcategoryId" class="category-select dCategory" required>
                                <option selected disabled>소분류 선택</option>
                              </select>
                            </div>
                          </div>
                        </div>
                        <div class="text-input">
                          <div class="div17">상품 재고수량</div>
                          <input type="number" name="stock" class="box2" min="0" required />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="frame-774">
                <button type="submit" class="button2"><span class="div21">저장</span></button>
              </div>
            </form>
          </div>
        </div>
      </main>
    </div>
    <div class="right-padding"></div>
  </div>
  <script>
  window.dCategoriesByU = {
    <c:forEach var="entry" items="${dCategoriesByU}" varStatus="loop">
      "${entry.key}": [
        <c:forEach var="d" items="${entry.value}" varStatus="loop2">
          { id: ${d.id}, name: "${d.name}" }<c:if test="${!loop2.last}">,</c:if>
        </c:forEach>
      ]<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  };

  function sendProductDataToServer() {
    console.log("sendProductDataToServer 함수 호출됨");
    console.log("현재 페이지 URL:", window.location.href);
    
    const productForms = $('.product-form-unit');
    const formData = new FormData();
    const dtoList = [];

    productForms.each(function(idx) {
      const form = this;
      const product = {
        productName: $(form).find('input[name="productName"]').val().trim(),
        price: parseInt($(form).find('input[name="price"]').val(), 10),
        productDetail: $(form).find('textarea[name="description"]').val().trim(),
        typeCategoryId: $(form).find('select[name="typeCategoryId"]').val(),
        dcategoryId: $(form).find('select[name="dcategoryId"]').val(),
        stock: parseInt($(form).find('input[name="stock"]').val(), 10),
        productDate: new Date().getTime(),
        saleCnt: 0,
        viewCnt: 0
      };

      dtoList.push({
        product: product,
        images: []  // 실제 파일은 FormData에 별도로
      });

      // 각 상품의 파일들을 명확한 키로 추가
      $(form).find('input[type="file"]').each(function(inputIdx) {
        const file = this.files[0];
        if (file) {
          formData.append(`product${idx}_image${inputIdx}`, file);
          console.log(`파일 추가: product${idx}_image${inputIdx}`, file.name);
        }
      });
    });

    // JSON 문자열로 추가
    formData.append('dtoList', JSON.stringify(dtoList));
    const finalUrl = '${cpath}' + `/legacy/${storeUrl}/seller/productinsert`;
    console.log("실제 전송 URL:", finalUrl);
    console.log("전송할 dtoList:", JSON.stringify(dtoList, null, 2));
    
    // FormData 내용 확인
    console.log("FormData 내용:");
    for (let pair of formData.entries()) {
      console.log(pair[0], typeof pair[1] === 'object' ? (pair[1].name || 'Blob') : pair[1]);
    }
    
    $.ajax({
      url: finalUrl,
      type: "POST",
      data: formData,
      processData: false,
      contentType: false,
      success: function(res) {
        console.log("서버 응답 성공:", res);
        alert("상품 등록 성공!");
        location.href = '${cpath}' + `/${storeUrl}/seller/products`;
      },
      error: function(xhr, status, error) {
        console.error("AJAX 에러 발생:");
        console.error("Status:", status);
        console.error("Error:", error);
        console.error("Response Text:", xhr.responseText);
        console.error("Response JSON:", xhr.responseJSON);
        alert("상품 등록 실패: " + (xhr.responseJSON?.message || error));
      }
    });
  }

  // jQuery로 이벤트 처리 (외부 JS 파일 실행 후에 실행되도록)
  $(document).ready(function() {
    console.log("jQuery document ready");
    
    // 기존 submit 이벤트 제거 후 새로 등록
    $("form").off("submit").on("submit", function(e) {
      console.log("jQuery Form submit 이벤트 발생");
      e.preventDefault();
      e.stopPropagation();
      
      sendProductDataToServer();
      return false;
    });
    
    // 저장 버튼 클릭 이벤트도 추가
    $('button[type="submit"]').off("click").on("click", function(e) {
      console.log("jQuery Submit button click 이벤트 발생");
      e.preventDefault();
      e.stopPropagation();
      
      sendProductDataToServer();
      return false;
    });
    
    console.log("이벤트 리스너 등록 완료");
  });
</script>

</body>
</html>