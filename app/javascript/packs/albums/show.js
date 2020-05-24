function popupImage() {
  var popup = document.getElementById('js-popup');
  if(!popup) return;

  $('.js-show-popup').on("click", function(){
    var imgsrc = $(this).attr('src');
    $('.popup-inner').find('img').attr('src',imgsrc);
    popup.classList.toggle('is-show');
  });

  $('#js-close-btn').on("click", function(){
    popup.classList.toggle('is-show');
  });

  $('#js-black-bg').on("click", function(){
    popup.classList.toggle('is-show');
  });
}
popupImage();
