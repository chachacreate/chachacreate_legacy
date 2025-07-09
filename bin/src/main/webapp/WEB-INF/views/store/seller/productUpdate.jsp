<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>뜨락상회 판매자 상품수정</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/productInsert.css">

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
  <script src="${cpath}/resources/js/seller/productUpdate.js"></script>
  <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
	const cpath = "${cpath}";
	window.product = ${productJson};
</script>
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
</script>
</head>
<body>
<div id="product-info"
     data-product-id="${product.productId}"
     data-store-url="${storeUrl}">
</div>
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
              <h2>상품 수정하기</h2>
            </div>

            <form id="updateProductForm" method="post" enctype="multipart/form-data">
              <div id="productFormUnit" class="product-form-unit">
                <div class="form-body-row">
                  <div class="frame-1076">
                    <label for="file-upload-1" class="frame-817-btn" aria-label="대표 이미지 등록"></label>
                    <input id="file-upload-1" name="imageFiles" type="file" accept="image/*" style="display:none;" />

                    <div class="frame-1077">
                      <label for="file-upload-2" class="frame-8152-btn">
                        <div class="frame-8152"></div>
                      </label>
                      <input id="file-upload-2" name="imageFiles" type="file" accept="image/*" style="display:none;" />

                      <label for="file-upload-3" class="frame-8152-btn">
                        <div class="frame-8152"></div>
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
                      <div class="text-area">
                        <div class="div17">상품 이름</div>
                        <input type="text" name="productName" class="box" value="${product.productName}" required />
                        <div class="counter-low">
                          <div class="_12">1</div>
                          <div class="_100">/50</div>
                        </div>
                      </div>

                      <div class="text-input">
                        <div class="div17">상품 가격</div>
                        <input type="number" name="price" class="box2" value="${product.price}" min="0" required />
                      </div>

                      <div class="text-area2">
                        <div class="div17">상품 설명</div>
                        <textarea name="description" class="box" required>${product.productDetail}</textarea>
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
								  <option value="${t.id}" <c:if test="${product.typeCategoryId == t.id}">selected</c:if>>${t.name}</option>
								</c:forEach>
						      </select>
						    </div>
						
						    <div class="frame-816">
						      <select name="category2" class="category-select uCategory" required style="font-size:14px; width:100%;">
						        <option selected disabled>중분류 선택</option>
						        <c:forEach var="u" items="${uCategories}">
								  <option value="${u.id}" <c:if test="${product.ucategoryId == u.id}">selected</c:if>>${u.name}</option>
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
                        <input type="number" name="stock" class="box2" value="${product.stock}" min="0" required />
                      </div>
                    </div>

                    <div class="frame-774">
                      <button type="submit" class="button2"><span class="div21">저장</span></button>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </main>
    </div>
  </div>
</div>
</body>
</html>