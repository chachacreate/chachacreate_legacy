document.addEventListener("DOMContentLoaded", function () {
  // 광고 배너 Swiper
  new Swiper('.banner-swiper', {
    loop: true,
    autoplay: {
      delay: 4000
    },
    pagination: {
      el: '.banner-swiper .banner-pagination',  // ✅ 범위 명확히
      clickable: true
    }
  });

  // 인기 스토어 Swiper
  new Swiper('.store-swiper', {
    slidesPerView: 3,
    spaceBetween: 30,
    loop: true,
    autoplay: { delay: 3000 },
    navigation: {
      nextEl: '.store-swiper .swiper-button-next',
      prevEl: '.store-swiper .swiper-button-prev',
    },
    pagination: {
      el: '.store-swiper .swiper-pagination',
      clickable: true,
    },
  });

  // 인기 상품 Swiper
  new Swiper('.product-swiper', {
    slidesPerView: 3,
    spaceBetween: 30,
    loop: true,
    autoplay: { delay: 3000 },
    navigation: {
      nextEl: '.product-swiper .swiper-button-next',
      prevEl: '.product-swiper .swiper-button-prev',
    },
    pagination: {
      el: '.product-swiper .swiper-pagination',
      clickable: true,
    },
  });

  // 임시 상품 링크 클릭 이벤트
  const links = document.querySelectorAll(".product-icon a");
  links.forEach(link => {
    link.addEventListener("click", e => {
      e.preventDefault();
      alert("상품 상세 페이지로 이동 예정입니다.");
    });
  });
});
