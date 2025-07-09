<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>뜨락상회 판매자 상품등록</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css" />
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/productInsert.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
  <script src="${cpath}/resources/js/seller/productInsert.js"></script>

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
	  const productForms = document.querySelectorAll('.product-form-unit');
	  const formData = new FormData();
	  const dtoList = [];

	  // 먼저 JSON으로 보낼 상품 정보만 따로 저장
	  [...productForms].forEach((form, idx) => {
	    const product = {
	      productName: form.querySelector('input[name="productName"]').value.trim(),
	      price: parseInt(form.querySelector('input[name="price"]').value, 10),
	      productDetail: form.querySelector('textarea[name="description"]').value.trim(),
	      typeCategoryId: form.querySelector('select[name="typeCategoryId"]').value,
	      dcategoryId: form.querySelector('select[name="dcategoryId"]').value,
	      stock: parseInt(form.querySelector('input[name="stock"]').value, 10),
	      productDate: new Date().getTime(),
	      saleCnt: 0,
	      viewCnt: 0
	    };

	    dtoList.push({
	      product: product,
	      images: [] // 실제 파일은 별도로 formData에 추가
	    });

	    // 파일은 formData에 따로 추가
	    const photoInputs = form.querySelectorAll('input[type="file"]');
	    [...photoInputs].forEach((input) => {
	      const file = input.files[0];
	      if (file) {
	        formData.append(`dtoList[\${idx}].images`, file);
	      }
	    });
	  });

	  // JSON을 Blob으로 변환하여 FormData에 추가
	  const jsonBlob = new Blob([JSON.stringify(dtoList)], { type: 'application/json' });
	  formData.append('dtoList', jsonBlob);

	  // 디버깅용
	  console.log("🚀 FormData 전송 내용:");
	  for (let pair of formData.entries()) {
	    console.log(pair[0], pair[1]);
	  }

	  $.ajax({
	    url: `${cpath}/${storeUrl}/seller/productinsert`,
	    type: "POST",
	    data: formData,
	    enctype: "multipart/form-data",
	    processData: false,
	    contentType: false,
	    success: res => {
	      console.log("서버 응답:", res);
	      alert("상품 등록 성공!");
	      location.href = `${cpath}/${storeUrl}/seller/products`;
	    },
	    error: err => {
	      console.error("에러:", err);
	      alert("상품 등록 실패");
	    }
	  });
	}

  // 폼 제출 시 수동 전송
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
    if (form) {
      form.addEventListener("submit", function (e) {
        e.preventDefault();
        sendProductDataToServer();
      });
    }
  });
</script>
</head>
<body>
<div class="wrapper">
  <header>
    <div class="header-inner">
      <div class="login-bar">
        <span>수제대추고님 반갑습니다.</span>
        <button class="logout-btn">로그아웃</button>
      </div>
    </div>
  </header>

  <div class="main-area">
    <div class="content-wrapper">
      <nav class="sidebar">
        <div class="profile-section" role="button" tabindex="0" aria-label="스토어관리 페이지로 이동" onclick="#">
          <img src="#" alt="프로필 이미지" class="profile-img" />
          <div class="store-name">수제대추고</div>
        </div>
        <ul class="menu-list">
          <li><a href="${cpath}/store1/seller/productinsert"><span class="menu-text">상품등록</span><span class="arrow">></span></a></li>
          <li><a href="${cpath}/store1/seller/products"><span class="menu-text">판매상품관리</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">주문/발송확인(취소/환불)</span><span class="arrow">></span></a></li>
          <li><a href="${cpath}/store1/seller/management/settlement"><span class="menu-text">정산관리</span><span class="arrow">></span></a></li>
          <li><a href="${cpath}/store1/seller/chat"><span class="menu-text">문의메시지</span><span class="arrow">></span></a></li>
          <li><a href="${cpath}/store1/seller/reviews"><span class="menu-text">리뷰관리</span><span class="arrow">></span></a></li>
          <li><a href="${cpath}/store1/seller/management/notices"><span class="menu-text">공지사항목록</span><span class="arrow">></span></a></li>
          <li><a href="#"><span class="menu-text">스토어관리</span><span class="arrow">></span></a></li>
        </ul>
        <div class="sidebar-footer">
          <button class="btn-go-buyer" onclick="location.href='${cpath}/store1/mypage'">구매자페이지 이동</button>
        </div>
      </nav>

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

            <!-- FORM 시작 -->
            <form method="post" enctype="multipart/form-data">
              <div id="productFormsContainer">

                <div class="product-form-unit" style="position:relative; width:100%; border:1px solid #ddd; padding:20px; margin-bottom:20px; border-radius:8px; background:#fff;">

                  <div class="form-body-row">
                    <div class="frame-1076">
                      <label for="file-upload-1" class="frame-817-btn" aria-label="추가 버튼">
                        <iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon>
                      </label>
                      <input id="file-upload-1" name="imageFiles" type="file" accept="image/*" style="display:none;" />

                      <div class="frame-1077">
                        <label for="file-upload-2" class="frame-8152-btn">
                          <div class="frame-8152">
                            <iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon>
                          </div>
                        </label>
                        <input id="file-upload-2" name="imageFiles" type="file" accept="image/*" style="display:none;" />

                        <label for="file-upload-3" class="frame-8152-btn">
                          <div class="frame-8152">
                            <iconify-icon icon="mdi:plus" class="icon-plus"></iconify-icon>
                          </div>
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
                        <button type="button" class="remove-product-btn"
                          style="position:absolute; top:10px; right:10px; background:#f44336; color:#fff; border:none; border-radius:4px; padding:4px 8px; cursor:pointer; font-weight:bold; font-size:14px;">
                          삭제
                        </button>

                        <div class="text-area">
                          <div class="div17">상품 이름</div>
                          <input type="text" name="productName" class="box" placeholder="내용을 입력하세요" required />
                          <div class="counter-low">
                            <div class="_12">1</div>
                            <div class="_100">/50</div>
                          </div>
                        </div>

                        <div class="text-input">
                          <div class="div17">상품 가격</div>
                          <input type="number" name="price" class="box2" placeholder="음수 X, number 1조 전까지" min="0" required />
                        </div>

                        <div class="text-area2">
                          <div class="div17">상품 설명</div>
                          <textarea name="description" class="box" placeholder="내용을 입력하세요" required></textarea>
                          <div class="counter-low">
                            <div class="_12">1</div>
                            <div class="_100">/3000</div>
                          </div>
                        </div>

                        <div class="group-90">
						  <div class="div20">상품 카테고리</div>
						  <div class="frame-10772" style="display:flex; gap:10px; align-items:center;">
						    <div class="frame-8153">
						      <select name="typeCategoryId" class="category-select" required style="font-size:14px; width:100%;">
						        <option selected disabled>대분류 선택</option>
						        <c:forEach var="t" items="${typeCategories}">
						          <option value="${t.id}">${t.name}</option>
						        </c:forEach>
						      </select>
						    </div>
						
						    <div class="frame-816">
						      <select name="category2" class="category-select uCategory" required style="font-size:14px; width:100%;">
						        <option selected disabled>중분류 선택</option>
						        <c:forEach var="u" items="${uCategories}">
						          <option value="${u.id}">${u.name}</option>
						        </c:forEach>
						      </select>
						    </div>
						
						    <div class="frame-8172">
						      <select name="dcategoryId" class="category-select dCategory" required style="font-size:14px; width:100%;">
						        <option selected disabled>소분류 선택</option>
						      </select>
						    </div>
						  </div>
						</div>

                        <div class="text-input">
                          <div class="div17">상품 재고수량</div>
                          <input type="number" name="stock" class="box2" placeholder="최대 9,999개" min="0" required />
                        </div>
                      </div>

                      <div class="frame-774" style="margin-top:10px;">
                        <!-- 개별 저장 버튼 없음 -->
                      </div>
                    </div>
                  </div>
                </div>
                <!-- /단일 폼 유닛 끝 -->

              </div>

              <div class="frame-774">
                <button type="submit" class="button2"><span class="div21">저장</span></button>
              </div>
            </form>
            <!-- FORM 끝 -->
          </div>
        </div>
      </main>
    </div>
  </div>
</div>
</body>
</html>