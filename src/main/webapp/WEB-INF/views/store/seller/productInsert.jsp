<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
            <form method="post" enctype="multipart/form-data">
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
                          <input type="text" name="productName" class="box" required />
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
</body>
</html>
