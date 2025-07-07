<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>개인 판매 물품 등록</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/personal/saleRegistration.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
  <!-- 반드시 Swiper CSS와 JS 포함되어 있어야 함 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

</head>
<body>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<main class="register-container">
  <jsp:include page="/common/main_personal_subnav.jsp" />

  <div class="explanation-box">
    <p>여기에는 개인판매 물품 등록하고 어쩌고 저쩌고 하는 방법들을 설명해놓는 칸입니다.<br>아래에는 접거나 사진을 넣고 만들 예정입니다.</p>
    <button class="open-store-btn">스토어 개설 신청</button>
  </div>

  <!-- ✅ Swiper 슬라이드 전체 -->
  <div class="swiper-container-wrapper">
    <div class="swiper mySwiper">
      <div class="swiper-wrapper">

        <!-- ✅ 슬라이드 1 -->
        <div class="swiper-slide">
          <div class="slide-full">
            <div class="slide-card">
              <div class="image-upload-wrapper">
                <div class="img-placeholder" id="upload-placeholder1"></div>
                <input type="file" id="fileInput1" accept="image/*" style="display: none;">
                <div class="img-placeholder" id="upload-placeholder2"></div>
                <input type="file" id="fileInput2" accept="image/*" style="display: none;">
                <div class="img-placeholder" id="upload-placeholder3"></div>
                <input type="file" id="fileInput3" accept="image/*" style="display: none;">
              </div>

              <div class="product-info">
			  <!-- 상품명 -->
			  <input type="hidden" id="productId" />
			  <div class="form-group">
			    <label for="productName">상품명</label>
			    <input type="text" id="productName" placeholder="이곳에 상품명을 입력하세요">
			  </div>
			
			  <!-- 가격 -->
			  <div class="form-group">
			    <label for="price">가격</label>
			    <div class="input-inline">
			      <input type="number" id="price" placeholder="가격을 입력하세요">
			      <span class="unit">원</span>
			    </div>
			  </div>
			
			  <!-- 재고 -->
			  <div class="form-group">
			    <label for="stock">재고</label>
			    <div class="input-inline">
			      <input type="number" id="stock" placeholder="재고 수량">
			      <span class="unit">개</span>
			    </div>
			  </div>
			
			  <!-- 카테고리 -->
			  <div class="form-group">
			    <label>카테고리</label>
			    <select id="typeCategory" class="category-select">
			    <option value="">대분류 선택</option>
			      <option value="METAL">금속공예</option>
				  <option value="WOOD">목공예</option>
				  <option value="CERAMIC">도자기공예</option>
				  <option value="GLASS">유리공예</option>
				  <option value="LEATHER">가죽공예</option>
				  <option value="RESIN">레진공예</option>
				  <option value="PLANT">식물공예</option>
				  <option value="KNITTING">뜨개질공예</option>
				  <option value="SEWING">양재공예</option>
				  <option value="TYPE_ETC">기타</option>
			    </select>
			    <select id="uCategory" name="uCategory" class="category-select">
			    <option value=''>중분류 선택</option>
			      <option value="FASHION">패션잡화</option>
				  <option value="INTERIOR">인테리어 소품</option>
				  <option value="ACCESSORY">악세서리</option>
				  <option value="LIFESTYLE">생활잡화</option>
				  <option value="ETC">기타</option>
			    </select>
			    <select id="dCategory" name="dCategory" class="category-select">
			    <option value="">소분류 선택</option>
			    </select>
			  </div>
			</div>
              
              
            </div>

			<button class="detail-toggle">상세페이지 만들기</button>
            <div class="detail-form" style="display:none;"> <!-- 여기에 display:none 추가 -->
			  <textarea id="productDetail" placeholder="판매 물품에 대한 상세 설명을 입력하세요."></textarea>
			</div>
            <div class="submit-section">
              <button id="submit-btn" class="submit-btn">판매 페이지에 상품 등록</button>
            </div>
            
            <!-- 수정/삭제 버튼 영역 -->
			<div class="action-buttons">
			  <button id="edit-btn" class="edit-btn" disabled>수정</button>
			  <button id="delete-btn" class="delete-btn" disabled>삭제</button>
			</div>
            
            
          </div>
        </div>

        <!-- ✅ 슬라이드 2 -->
        <div class="swiper-slide">
          <div class="slide-full">
            <div class="slide-card">
              <div class="image-upload-wrapper">
                <div class="img-placeholder" id="upload-placeholder4"></div>
                <input type="file" id="fileInput4" accept="image/*" style="display: none;">
                <div class="img-placeholder" id="upload-placeholder5"></div>
                <input type="file" id="fileInput5" accept="image/*" style="display: none;">
                <div class="img-placeholder" id="upload-placeholder6"></div>
                <input type="file" id="fileInput6" accept="image/*" style="display: none;">
              </div>

              <div class="product-info">
			  <!-- 상품명 -->
			  <input type="hidden" id="productId2" />
			  <div class="form-group">
			    <label for="productName">상품명</label>
			    <input type="text" id="productName2" placeholder="이곳에 상품명을 입력하세요">
			  </div>
			
			  <!-- 가격 -->
			  <div class="form-group">
			    <label for="price">가격</label>
			    <div class="input-inline">
			      <input type="number" id="price2" placeholder="가격을 입력하세요">
			      <span class="unit">원</span>
			    </div>
			  </div>
			
			  <!-- 재고 -->
			  <div class="form-group">
			    <label for="stock">재고</label>
			    <div class="input-inline">
			      <input type="number" id="stock2" placeholder="재고 수량">
			      <span class="unit">개</span>
			    </div>
			  </div>
			
			  <!-- 카테고리 -->
			  <div class="form-group">
			    <label>카테고리</label>
			    <select id="typeCategory2" class="category-select">
			    <option value="">대분류 선택</option>
			      <option value="METAL">금속공예</option>
				  <option value="WOOD">목공예</option>
				  <option value="CERAMIC">도자기공예</option>
				  <option value="GLASS">유리공예</option>
				  <option value="LEATHER">가죽공예</option>
				  <option value="RESIN">레진공예</option>
				  <option value="PLANT">식물공예</option>
				  <option value="KNITTING">뜨개질공예</option>
				  <option value="SEWING">양재공예</option>
				  <option value="TYPE_ETC">기타</option>
			    </select>
			    <select id="uCategory2" name="uCategory" class="category-select">
			    <option value=''>중분류 선택</option>
			      <option value="FASHION">패션잡화</option>
				  <option value="INTERIOR">인테리어 소품</option>
				  <option value="ACCESSORY">악세서리</option>
				  <option value="LIFESTYLE">생활잡화</option>
				  <option value="ETC">기타</option>
			    </select>
			    <select id="dCategory2" name="dCategory" class="category-select">
			    <option value="">소분류 선택</option>
			    </select>
			  </div>
			</div>
              
              
            </div>

			<button class="detail-toggle">상세페이지 만들기</button>
            <div class="detail-form" style="display:none;"> <!-- 여기에 display:none 추가 -->
			  <textarea id="productDetail2" placeholder="판매 물품에 대한 상세 설명을 입력하세요."></textarea>
			</div>
            <div class="submit-section">
              <button id="submit-btn2" class="submit-btn">판매 페이지에 상품 등록</button>
            </div>
            
            <!-- 수정/삭제 버튼 영역 -->
			<div class="action-buttons">
			  <button id="edit-btn2" class="edit-btn" disabled>수정</button>
			  <button id="delete-btn2" class="delete-btn" disabled>삭제</button>
			</div>
            
            
          </div>
        </div>
        
      </div>

      <!-- ✅ Swiper 네비게이션 -->
      <div class="swiper-button-prev"></div>
      <div class="swiper-button-next"></div>
    </div>
  </div>
</main>

<footer>
  <div class="footer-inner">
    <div class="footer-logo">뜨락상회</div>
    <p>마음을 모은 생활 복지 플랫폼</p>
    <div class="footer-inputs">
      <input type="text" placeholder="연락처">
      <input type="text" placeholder="연락처2">
    </div>
  </div>
</footer>


<script>

// --------------Swiper 슬라이더 초기화/ 작동중--------------------------
const swiper = new Swiper('.mySwiper', {
  slidesPerView: 1,
  spaceBetween: 30,
  loop: false,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
});

//----------------카테고리----------------------
$(function() {
  const dCategoryOptions = {
    FASHION: [
      { value: "TOP", text: "상의" },
      { value: "BOTTOM", text: "하의" },
      { value: "BAG", text: "가방" },
      { value: "WALLET", text: "지갑" },
      { value: "FASHION_ETC", text: "기타(목도리, 모자, 벨트 등)" }
    ],
    INTERIOR: [
      { value: "DIFFUSER", text: "디퓨저, 캔들" },
      { value: "MOOD_LIGHT", text: "무드등" },
      { value: "FLOWER_PLANT", text: "꽃, 식물" },
      { value: "FURNITURE", text: "가구" }
    ],
    ACCESSORY: [
      { value: "RING", text: "반지" },
      { value: "BRACELET", text: "팔찌" },
      { value: "NECKLACE", text: "목걸이" },
      { value: "KEYRING", text: "키링" }
    ],
    LIFESTYLE: [
      { value: "SOAP", text: "비누" },
      { value: "DISH", text: "그릇" },
      { value: "TABLEWARE", text: "식기류" },
      { value: "CUP", text: "컵" },
      { value: "CASE", text: "케이스" }
    ],
    ETC: [
      { value: "PERFUME", text: "향수" },
      { value: "DOLL", text: "인형" },
      { value: "PET", text: "반려동물" },
      { value: "STATIONERY", text: "문구" }
    ]
  };

  $('#uCategory').on('change', function() {
    const selected = $(this).val();
    const $dCategory = $('#dCategory');

    $dCategory.empty();
    $dCategory.append('<option value="">소분류 선택</option>');

    if (selected && dCategoryOptions[selected]) {
      $.each(dCategoryOptions[selected], function(_, option) {
        $dCategory.append($('<option></option>').val(option.value).text(option.text));
      });
    }
  });
  
  $('#uCategory2').on('change', function() {
	    const selected = $(this).val();
	    const $dCategory = $('#dCategory2');

	    $dCategory.empty();
	    $dCategory.append('<option value="">소분류 선택</option>');

	    if (selected && dCategoryOptions[selected]) {
	      $.each(dCategoryOptions[selected], function(_, option) {
	        $dCategory.append($('<option></option>').val(option.value).text(option.text));
	      });
	    }
	  });
});

$(function() {
  // ✅ 기타 jQuery 이벤트들
  $('.detail-toggle').click(function () {
    $(this).next('.detail-form').slideToggle();
  });

  $('#add-category').click(function () {
    $('#category-box').append(`<span class="category-item">카테고리1</span>`);
  });

  $('#add-category2').click(function () {
    $('#category-box2').append(`<span class="category-item">카테고리2</span>`);
  });

});

//----------------------------기존 상품 데이터 가져오기------------------------------
pimgUrl1 = null, pimgUrl2 = null, pimgUrl3 = null;
pimgUrl4 = null, pimgUrl5 = null, pimgUrl6 = null;
$(document).ready(function () {
    // 상품 데이터를 받아오는 AJAX 요청
    $.ajax({
        url: '${cpath}/api/main/sell/products', // 요청 URL
        type: 'GET', // GET 방식으로 요청
        dataType: 'json', // JSON 응답 처리
        success: function (response) {
            if (response.status === 200) {
                const products = response.data;
                console.log(products);
                // 상품이 2개 이상 있을 경우 슬라이드 1과 2에 데이터 채우기
                if (products.length >= 1) {
                    // 첫 번째 슬라이드 (슬라이드 1) 상품 데이터 채우기
                    $('#productId').val(products[0].productId);
                    $('#productName').val(products[0].productName);
                    $('#productDetail').val(products[0].productDetail);
                    $('#price').val(products[0].price);
                    $('#stock').val(products[0].stock);
                    $('#typeCategory option').each(function () {
                    	  if ($(this).text().trim() === products[0].typeCategoryId) {
                    	    $(this).prop('selected', true);
                    	  }
                    	});
                    $('#uCategory option').each(function () {
                  	  if ($(this).text().trim() === products[0].ucategoryId) {
                  	    $(this).prop('selected', true);
                  	  }
                  	});
                    $('#uCategory').trigger('change'); //change 트리거
                  	setTimeout(function () {
                      	$('#dCategory option').each(function () {
                            if ($(this).val() === products[0].dcategoryId) {
                              $(this).prop('selected', true);
                            }
                          });
                  	}, 100); // 약간의 딜레이 필요 (select options가 완전히 갱신된 후)
                  	if (products[0].pimgUrl1){
                    	pimgUrl1 = `\${products[0].pimgUrl1}`;
                    	$('#upload-placeholder1').html(`<img src="${cpath}/resources/productImages/\${products[0].pimgUrl1}">`);
                  	}
                  	if (products[0].pimgUrl2){
                    	pimgUrl2 = `\${products[0].pimgUrl2}`;
                    	$('#upload-placeholder2').html(`<img src="${cpath}/resources/productImages/\${products[0].pimgUrl2}">`);
                  	}
                    if (products[0].pimgUrl3){
                    	pimgUrl3 = `\${products[0].pimgUrl3}`;
                    	$('#upload-placeholder3').html(`<img src="${cpath}/resources/productImages/\${products[0].pimgUrl3}">`);
                    }
                 	// 첫 번째 슬라이드 input/textarea 비활성화
                    $('#productName, #productDetail, #price, #stock, #typeCategory, #uCategory, #dCategory').prop('disabled', true);
                 	// 이미지 업로드 비활성화
                    $('#fileInput1, #fileInput2, #fileInput3').prop('disabled', true);
                    // 상품 등록 버튼 비활성화
                    $('#submit-btn').prop('disabled', true);
                    // 첫 번째 슬라이드 수정/삭제 버튼 활성화
                    $('#edit-btn').prop('disabled', false);
                    $('#delete-btn').prop('disabled', false);
                }

                if (products.length >= 2) {
                    // 두 번째 슬라이드 (슬라이드 2) 상품 데이터 채우기
                    $('#productId2').val(products[1].productId);
                    $('#productName2').val(products[1].productName);
                    $('#productDetail2').val(products[1].productDetail);
                    $('#price2').val(products[1].price);
                    $('#stock2').val(products[1].stock);
                    $('#typeCategory2 option').each(function () {
                  	  if ($(this).text().trim() === products[1].typeCategoryId) {
                  	    $(this).prop('selected', true);
                  	  }
                  	});
                  $('#uCategory2 option').each(function () {
                	  if ($(this).text().trim() === products[1].ucategoryId) {
                	    $(this).prop('selected', true);
                	  }
                	});
                  $('#uCategory2').trigger('change'); // change 트리거
                	setTimeout(function () {
                    	$('#dCategory2 option').each(function () {
                          if ($(this).val() === products[1].dcategoryId) {
                            $(this).prop('selected', true);
                          }
                        });
                	}, 100); // 약간의 딜레이 필요 (select options가 완전히 갱신된 후)
                  	if (products[1].pimgUrl1){
                    	pimgUrl4 = `\${products[1].pimgUrl1}`;
                    	$('#upload-placeholder4').html(`<img src="${cpath}/resources/productImages/\${products[1].pimgUrl1}">`);
                  	}
                  	if (products[1].pimgUrl2){
                    	pimgUrl5 = `\${products[1].pimgUrl2}`;
                    	$('#upload-placeholder5').html(`<img src="${cpath}/resources/productImages/\${products[1].pimgUrl2}">`);
                  	}
                    if (products[1].pimgUrl3){
                   		pimgUrl6 = `\${products[1].pimgUrl3}`;
                   		$('#upload-placeholder6').html(`<img src="${cpath}/resources/productImages/\${products[1].pimgUrl3}">`);
                    }
                 	// 두 번째 슬라이드 input/textarea 비활성화
                    $('#productName2, #productDetail2, #price2, #stock2, #typeCategory2, #uCategory2, #dCategory2').prop('disabled', true);
                 	// 이미지 업로드 비활성화
                 	$('#fileInput4, #fileInput5, #fileInput6').prop('disabled', true);
                 	// 상품 등록 버튼 비활성화
                    $('#submit-btn2').prop('disabled', true);
                    // 두 번째 슬라이드 수정/삭제 버튼 활성화
                    $('#edit-btn2').prop('disabled', false);
                    $('#delete-btn2').prop('disabled', false);
                }

            }
        },
        error: function (error) {
            console.error("상품 정보를 불러오는 데 실패했습니다.", error);
        }
    });
});

//-----------------파일 이름 저장 및 미리보기--------------------

// 각 이미지 업로드 이벤트 연결
for (let i = 1; i <= 6; i++) {
  $(`#upload-placeholder\${i}`).on('click', function () {
    $(`#fileInput\${i}`).click();
  });

  $(`#fileInput\${i}`).on('change', function (e) {
    const file = e.target.files[0];
    if (!file) return;

    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    const fileName = file.name.toLowerCase();
    const extension = fileName.split('.').pop();

    if (!allowedExtensions.includes(extension)) {
      alert('jpg, jpeg, png, gif 형식의 이미지 파일만 업로드할 수 있습니다.');
      $(this).val('');  // 파일 선택 초기화
      return;
    }

    // 파일 이름 저장
    if (i === 1) pimgUrl1 = file.name;
    else if (i === 2) pimgUrl2 = file.name;
    else if (i === 3) pimgUrl3 = file.name;
    else if (i === 4) pimgUrl4 = file.name;
    else if (i === 5) pimgUrl5 = file.name;
    else if (i === 6) pimgUrl6 = file.name;

    // 이미지 미리보기 반영
    $(`#upload-placeholder\${i}`).html(`<img src="${cpath}/resources/productImages/\${file.name}"
    		style="max-width: 100%; max-height: 100%; object-fit: contain; display: block;">`
    	);
  });
}

//-------------------상품등록-----------------------
$('#submit-btn').click(function () {
  const productName = $('#productName').val().trim();
  const productDetail = $('#productDetail').val().trim();
  const price = $('#price').val().trim();
  const stock = $('#stock').val().trim();
  const typeCategoryId = $('#typeCategory').val();
  const ucategoryId = $('#uCategory').val();
  const dcategoryId = $('#dCategory').val();

  if (!productName) {
    alert('상품명을 입력해주세요.');
    $('#productName').focus();
    return;
  }
  if (!price) {
    alert('가격을 입력해주세요.');
    $('#price').focus();
    return;
  }
  if (!stock) {
    alert('재고를 입력해주세요.');
    $('#stock').focus();
    return;
  }
  if (!typeCategoryId) {
    alert('대분류를 선택해주세요.');
    $('#typeCategory').focus();
    return;
  }
  if (!ucategoryId) {
    alert('중분류를 선택해주세요.');
    $('#uCategory').focus();
    return;
  }
  if (!dcategoryId) {
    alert('소분류를 선택해주세요.');
    $('#dCategory').focus();
    return;
  }
  if (!productDetail) {
    alert('상세설명을 입력해주세요.');
    $('#productDetail').focus();
    return;
  }

  const data = {
    productName,
    productDetail,
    price: parseInt(price),
    stock: parseInt(stock),
    typeCategoryId,
    ucategoryId,
    dcategoryId,
    pimgUrl1: pimgUrl1,
    pimgUrl2: pimgUrl2,
    pimgUrl3: pimgUrl3
  };

  $.ajax({
    url: '${cpath}/api/main/sell/sellregister',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function (response) {
      if (response.status === 201) {
        alert('상품 등록이 완료되었습니다.');
        $('.swiper-slide').eq(0).find('.edit-btn, .delete-btn').prop('disabled', false);
      } else {
        alert('상품 등록 실패');
      }
    },
    error: function (xhr) {
      alert('상품 등록 실패: ' + xhr.responseText);
    }
  });
});

//-------------------상품 수정 1-------------------------
// 수정 버튼 클릭 이벤트
$('#edit-btn').on('click', function() {
    // 입력창들이 모두 활성화 상태인지 체크
    const isEnabled = !$('#productName').prop('disabled');

    if (!isEnabled) {
        // 비활성화 상태면 활성화 시키기
        $('#productName, #productDetail, #price, #stock, #typeCategory, #uCategory, #dCategory').prop('disabled', false);
        $('#fileInput1, #fileInput2, #fileInput3').prop('disabled', false);
    } else {
   		  const productId = $('#productId').val().trim();
   		  const productName = $('#productName').val().trim();
    	  const productDetail = $('#productDetail').val().trim();
    	  const price = $('#price').val().trim();
    	  const stock = $('#stock').val().trim();
    	  const typeCategoryId = $('#typeCategory').val();
    	  const ucategoryId = $('#uCategory').val();
    	  const dcategoryId = $('#dCategory').val();

    	  if (!productName) {
    	    alert('상품명을 입력해주세요.');
    	    $('#productName').focus();
    	    return;
    	  }
    	  if (!price) {
    	    alert('가격을 입력해주세요.');
    	    $('#price').focus();
    	    return;
    	  }
    	  if (!stock) {
    	    alert('재고를 입력해주세요.');
    	    $('#stock').focus();
    	    return;
    	  }
    	  if (!typeCategoryId) {
    	    alert('대분류를 선택해주세요.');
    	    $('#typeCategory').focus();
    	    return;
    	  }
    	  if (!ucategoryId) {
    	    alert('중분류를 선택해주세요.');
    	    $('#uCategory').focus();
    	    return;
    	  }
    	  if (!dcategoryId) {
    	    alert('소분류를 선택해주세요.');
    	    $('#dCategory').focus();
    	    return;
    	  }
    	  if (!productDetail) {
    	    alert('상세설명을 입력해주세요.');
    	    $('#productDetail').focus();
    	    return;
    	  }

    	  const data = {
    	    productId,
    	    productName,
    	    productDetail,
    	    price: parseInt(price),
    	    stock: parseInt(stock),
    	    typeCategoryId,
    	    ucategoryId,
    	    dcategoryId,
    	    pimgUrl1: pimgUrl1,
    	    pimgUrl2: pimgUrl2,
    	    pimgUrl3: pimgUrl3
    	  };
		console.log(data);
        $.ajax({
            url: '${cpath}/api/main/sell/sellregister/update',
            method: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function(response) {
                alert('수정이 완료되었습니다.');
                $('#productName, #productDetail, #price, #stock, #typeCategory, #uCategory, #dCategory').prop('disabled', true);
                $('#fileInput1, #fileInput2, #fileInput3').prop('disabled', true);
            },
            error: function(err) {
                alert('수정 중 오류가 발생했습니다.');
            }
        });
    }
});


//-------------------상품 삭제 1-------------------------
  $('#delete-btn').on('click', function () {
	  const productId = $('#productId').val().trim();

    $.ajax({
      url: '${cpath}/api/main/sell/sellregister/delete',
      type: 'PUT',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ productId: parseInt(productId) }),
      success: function (response) {
        if (response.status === 200) {
        	location.reload();
          alert('상품이 성공적으로 삭제되었습니다.');
        } else {
          alert('상품 삭제에 실패했습니다: ' + (response.message || '알 수 없는 오류'));
        }
      },
      error: function (xhr, status, error) {
        alert('서버 오류: ' + error);
      }
    });
  });

//-------------------상품 등록 2-------------------------
$('#submit-btn2').click(function () {
	  const productName = $('#productName2').val().trim();
	  const productDetail = $('#productDetail2').val().trim();
	  const price = $('#price2').val().trim();
	  const stock = $('#stock2').val().trim();
	  const typeCategoryId = $('#typeCategory2').val();
	  const ucategoryId = $('#uCategory2').val();
	  const dcategoryId = $('#dCategory2').val();

	  if (!productName) {
	    alert('상품명을 입력해주세요.');
	    $('#productName2').focus();
	    return;
	  }
	  if (!price) {
	    alert('가격을 입력해주세요.');
	    $('#price2').focus();
	    return;
	  }
	  if (!stock) {
	    alert('재고를 입력해주세요.');
	    $('#stock2').focus();
	    return;
	  }
	  if (!typeCategoryId) {
	    alert('대분류를 선택해주세요.');
	    $('#typeCategory2').focus();
	    return;
	  }
	  if (!ucategoryId) {
	    alert('중분류를 선택해주세요.');
	    $('#uCategory2').focus();
	    return;
	  }
	  if (!dcategoryId) {
	    alert('소분류를 선택해주세요.');
	    $('#dCategory2').focus();
	    return;
	  }
	  if (!productDetail) {
	    alert('상세설명을 입력해주세요.');
	    $('#productDetail2').focus();
	    return;
	  }

	  const data = {
	    productName,
	    productDetail,
	    price: parseInt(price),
	    stock: parseInt(stock),
	    typeCategoryId,
	    ucategoryId,
	    dcategoryId,
	    pimgUrl1: pimgUrl4,
	    pimgUrl2: pimgUrl5,
	    pimgUrl3: pimgUrl6
	  };

	  $.ajax({
	    url: '${cpath}/api/main/sell/sellregister',
	    method: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(data),
	    success: function (response) {
	      if (response.status === 201) {
	        alert('상품 등록이 완료되었습니다.');
	        $('.swiper-slide').eq(1).find('.edit-btn, .delete-btn').prop('disabled', false);
	      } else {
	        alert('상품 등록 실패');
	      }
	    },
	    error: function (xhr) {
	      alert('상품 등록 실패: ' + xhr.responseText);
	    }
	  });
	});

//-------------------상품 수정 2-------------------------
//수정 버튼 클릭 이벤트
$('#edit-btn2').on('click', function() {
 // 입력창들이 모두 활성화 상태인지 체크
 const isEnabled = !$('#productName2').prop('disabled');

 if (!isEnabled) {
     // 비활성화 상태면 활성화 시키기
     $('#productName2, #productDetail2, #price2, #stock2, #typeCategory2, #uCategory2, #dCategory2').prop('disabled', false);
     $('#fileInput4, #fileInput5, #fileInput6').prop('disabled', false);
 } else {
		  const productId = $('#productId2').val().trim();
		  const productName = $('#productName2').val().trim();
 	  const productDetail = $('#productDetail2').val().trim();
 	  const price = $('#price2').val().trim();
 	  const stock = $('#stock2').val().trim();
 	  const typeCategoryId = $('#typeCategory2').val();
 	  const ucategoryId = $('#uCategory2').val();
 	  const dcategoryId = $('#dCategory2').val();

 	  if (!productName) {
 	    alert('상품명을 입력해주세요.');
 	    $('#productName2').focus();
 	    return;
 	  }
 	  if (!price) {
 	    alert('가격을 입력해주세요.');
 	    $('#price2').focus();
 	    return;
 	  }
 	  if (!stock) {
 	    alert('재고를 입력해주세요.');
 	    $('#stock2').focus();
 	    return;
 	  }
 	  if (!typeCategoryId) {
 	    alert('대분류를 선택해주세요.');
 	    $('#typeCategory2').focus();
 	    return;
 	  }
 	  if (!ucategoryId) {
 	    alert('중분류를 선택해주세요.');
 	    $('#uCategory2').focus();
 	    return;
 	  }
 	  if (!dcategoryId) {
 	    alert('소분류를 선택해주세요.');
 	    $('#dCategory2').focus();
 	    return;
 	  }
 	  if (!productDetail) {
 	    alert('상세설명을 입력해주세요.');
 	    $('#productDetail2').focus();
 	    return;
 	  }

 	  const data = {
 	    productId,
 	    productName,
 	    productDetail,
 	    price: parseInt(price),
 	    stock: parseInt(stock),
 	    typeCategoryId,
 	    ucategoryId,
 	    dcategoryId,
 	    pimgUrl1: pimgUrl4,
 	    pimgUrl2: pimgUrl5,
 	    pimgUrl3: pimgUrl6
 	  };
		console.log(data);
     $.ajax({
         url: '${cpath}/api/main/sell/sellregister/update',
         method: 'PUT',
         contentType: 'application/json',
         data: JSON.stringify(data),
         success: function(response) {
             alert('수정이 완료되었습니다.');
             $('#productName2, #productDetail2, #price2, #stock2, #typeCategory2, #uCategory2, #dCategory2').prop('disabled', true);
             $('#fileInput4, #fileInput5, #fileInput6').prop('disabled', true);
         },
         error: function(err) {
             alert('수정 중 오류가 발생했습니다.');
         }
     });
 }
 
 
});

//-------------------상품 삭제 2-------------------------
$('#delete-btn2').on('click', function () {
	  const productId = $('#productId2').val().trim();

  $.ajax({
    url: '${cpath}/api/main/sell/sellregister/delete',
    type: 'PUT',
    contentType: 'application/json',
    dataType: 'json',
    data: JSON.stringify({ productId: parseInt(productId) }),
    success: function (response) {
      if (response.status === 200) {
      	location.reload();
        alert('상품이 성공적으로 삭제되었습니다.');
      } else {
        alert('상품 삭제에 실패했습니다: ' + (response.message || '알 수 없는 오류'));
      }
    },
    error: function (xhr, status, error) {
      alert('서버 오류: ' + error);
    }
  });
});
</script>


</body>
</html>
