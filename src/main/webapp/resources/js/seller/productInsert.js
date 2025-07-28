$(function() {
  const productFormsContainer = $("#productFormsContainer");
  const productFormUnitSelector = ".product-form-unit";

  // 복제용 템플릿 (처음 폼을 복제)
  let productFormTemplate = productFormsContainer.find(productFormUnitSelector).first().clone();

  function resetIndexes() {
  productFormsContainer.find(productFormUnitSelector).each(function(index){
    const $form = $(this);

    // ✅ 이미지 input과 label의 id/for 속성만 갱신
    $form.find("input[type=file]").each(function(i){
      const newId = `file-upload-${i + 1}-${index}`;
      $(this).attr("id", newId);
      $form.find(`label[for^=file-upload]`).eq(i).attr("for", newId);
    });
  });
}

  // 중분류 변경시 소분류 options 변경
  productFormsContainer.on('change', '.uCategory', function() {
    const selectedUId = $(this).val();
    const dOptions = dCategoriesByU[selectedUId] || [];

    const $dSelect = $(this).closest('.product-form-unit').find('.dCategory');
    $dSelect.empty();
    $dSelect.append('<option disabled selected>소분류 선택</option>');

    dOptions.forEach(d => {
      $dSelect.append(`<option value="${d.id}">${d.name}</option>`);
    });
  });

  // + 상품 추가 버튼 클릭
  $("#addProductBtn").on("click", function(){
    const newForm = productFormTemplate.clone();
    newForm.find("input[type=text], input[type=number], textarea").val("");
    newForm.find("select").prop('selectedIndex', 0);
    newForm.find("input[type=file]").val("");
    newForm.find('.frame-817-btn, .frame-8152-btn').css('background-image', '').removeClass('has-image');
    productFormsContainer.prepend(newForm);
    resetIndexes();
  });

  // 삭제 버튼 클릭 이벤트 (위임)
  productFormsContainer.on("click", ".remove-product-btn", function(){
    if(productFormsContainer.find(productFormUnitSelector).length <= 1){
      alert("최소 한 개 이상의 상품 폼은 있어야 합니다.");
      return;
    }
    if(confirm("이 상품 등록 폼을 삭제하시겠습니까?")){
      $(this).closest(productFormUnitSelector).remove();
      resetIndexes();
    }
  });

  // 이미지 선택시 배경에 미리보기 세팅
  productFormsContainer.on('change', 'input[type="file"]', function(e) {
  const fileInput = this;
  const file = fileInput.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = function(event) {
    const imgSrc = event.target.result;
    // input의 id를 얻고, 같은 for를 가진 label을 찾아서 배경 설정
    const inputId = $(fileInput).attr('id');
    const wrapper = $(`label[for="${inputId}"]`);
    wrapper.css('background-image', `url(${imgSrc})`);
    wrapper.addClass('has-image');
  };
  reader.readAsDataURL(file);
});

  // 초기 인덱스 세팅
  resetIndexes();
});