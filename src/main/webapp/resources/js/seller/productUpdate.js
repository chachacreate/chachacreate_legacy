$(function () {
  const $form = $('#productFormUnit');
  const productId = $('#product-info').data('product-id');
  const storeUrl = $('#product-info').data('store-url');
  const updateProductForm = $("#updateProductForm");
  const product = window.product || {};

  // 이름으로 select 옵션 찾아서 선택하는 함수
  function selectByName(selector, name) {
    const $select = $(selector);
    if (!name) return;

    const $option = $select.find('option').filter(function() {
      return $(this).text() === name;
    });

    if ($option.length) {
      $select.val($option.val());
    }
  }

  // 미리보기 기능(input시)
  $form.on('change', 'input[type="file"]', function () {
    const fileInput = this;
    const file = fileInput.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (event) {
      const imgSrc = event.target.result;
      const inputId = $(fileInput).attr('id');
      const label = $(`label[for="${inputId}"]`);
      label.css('background-image', `url(${imgSrc})`).addClass('has-image');
    };
    reader.readAsDataURL(file);
  });

  // 이미지 미리보기 (기존 이미지)
  const previewImg = (selector, filename) => {
  if (!filename) return;
  
  // 파일 경로 구성: /resources/productImages/{파일명}
  const finalUrl = cpath + "/resources/productImages/" + filename;

  const $label = $(`label[for="${selector}"]`);
  $label.css("background-image", `url(${finalUrl})`).addClass("has-image");
	};
	
	// DB에 저장된 파일명만 전달됨
	previewImg("file-upload-1", product.pimgUrl1);
	previewImg("file-upload-2", product.pimgUrl2);
	previewImg("file-upload-3", product.pimgUrl3);

  // 카테고리 자동 선택 (이름 기준)
  selectByName('select[name="typeCategoryId"]', product.typeCategoryName);
  selectByName('select[name="category2"]', product.ucategoryName);

  // 중분류 변경 시 소분류 select 옵션 세팅 후, 이름 기준 선택
  const $uCategorySelect = $('select[name="category2"]');
  const dOptions = window.dCategoriesByU && window.dCategoriesByU[$uCategorySelect.val()] || [];
  const $dSelect = $('select[name="dcategoryId"]');
  $dSelect.empty();
  $dSelect.append('<option disabled selected>소분류 선택</option>');
  dOptions.forEach(d => {
    $dSelect.append(`<option value="${d.id}">${d.name}</option>`);
  });
  selectByName('select[name="dcategoryId"]', product.dcategoryName);

  // 중분류 변경시 소분류 변경 이벤트
  updateProductForm.on('change', '.uCategory', function() {
    const selectedUId = $(this).val();
    const dOptions = dCategoriesByU[selectedUId] || [];

    const $dSelect = $(this).closest('.product-form-unit').find('.dCategory');
    $dSelect.empty();
    $dSelect.append('<option disabled selected>소분류 선택</option>');

    dOptions.forEach(d => {
      $dSelect.append(`<option value="${d.id}">${d.name}</option>`);
    });
  });

  // 폼 제출
  $('#updateProductForm').on('submit', function (e) {
  e.preventDefault();

  const formData = new FormData();

  const product = {
    productId: productId, // ← 반드시 포함
    productName: $form.find('[name="productName"]').val().trim(),
    price: parseInt($form.find('[name="price"]').val(), 10),
    productDetail: $form.find('[name="description"]').val().trim(),
    typeCategoryId: $form.find('[name="typeCategoryId"]').val(),
    dcategoryId: $form.find('[name="dcategoryId"]').val(),
    stock: parseInt($form.find('[name="stock"]').val(), 10),
  };

  formData.append('dto', new Blob([JSON.stringify(product)], { type: 'application/json' }));

  $form.find('input[type="file"]').each((_, input) => {
    const file = input.files[0];
    if (file) {
      formData.append('images', file);
      const seq = $(input).attr("id").split("-").pop(); // ex) file-upload-2 → 2
      formData.append('imageSeqs', parseInt(seq, 10));
    }
  });

  $.ajax({
    url: `${cpath}/${storeUrl}/seller/productupdate/${productId}`,
    method: 'POST',
    data: formData,
    enctype: "multipart/form-data",
    processData: false,
    contentType: false,
    success: function () {
      alert("수정 성공!");
      location.href = `${cpath}/${storeUrl}/seller/products`;
    },
    error: function (err) {
      console.error("수정 실패", err);
      alert("상품 수정 실패");
    }
  });
});
});