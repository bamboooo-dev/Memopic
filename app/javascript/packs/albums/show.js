function popupImage() {
  var popup = document.getElementById('js-popup');
  if(!popup) return;

  $('.js-show-popup').on("click", function(){
    if($(this).prop('tagName') == 'IMG'){
      var imgsrc = $(this).attr('src');
      $('.popup-inner').find('img').attr('src',imgsrc);
    }
    popup.classList.toggle('is-show');
  });

  $('#js-close-btn').on("click", function(){
    $('.popup-content').html('<img>');
    popup.classList.toggle('is-show');
  });

  $('#js-black-bg').on("click", function(){
    $('.popup-content').html('<img>');
    popup.classList.toggle('is-show');
  });
}
popupImage();
