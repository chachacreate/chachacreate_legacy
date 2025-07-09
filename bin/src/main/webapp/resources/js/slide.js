document.addEventListener("DOMContentLoaded", function () {

    function initSlider(sliderClass, leftBtnId, rightBtnId, itemWidth, gap, visibleItems) {
        const slider = document.querySelector(sliderClass);
        const slideLeft = document.getElementById(leftBtnId);
        const slideRight = document.getElementById(rightBtnId);
        const items = slider.querySelectorAll('.product-card');
        const totalItems = items.length;

        let currentSlide = 0;
        const maxSlide = totalItems - visibleItems;
        const moveDistance = itemWidth + gap;

        slideLeft.addEventListener('click', () => {
            if (currentSlide > 0) {
                currentSlide--;
                slider.style.transform = `translateX(-${currentSlide * moveDistance}px)`;
            }
        });

        slideRight.addEventListener('click', () => {
            if (currentSlide < maxSlide) {
                currentSlide++;
                slider.style.transform = `translateX(-${currentSlide * moveDistance}px)`;
            }
        });
    }

    // 상품 슬라이더 초기화
    initSlider('#product-slider', 'productSlideLeft', 'productSlideRight', 300, 30, 3);

});
