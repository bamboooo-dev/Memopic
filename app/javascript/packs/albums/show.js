function popupImage() {
  var popup = document.getElementById('js-popup');
  if(!popup) return;

  $('.js-show-popup').on("click", function(){
    if($(this).prop('tagName') == 'IMG'){
      $('.popup-content').prepend('<img>');
      var imgsrc = $(this).attr('src');
      $('.popup-content').find('img').attr('src',imgsrc);
    }
    popup.classList.toggle('is-show');
  });

  $('#js-close-btn').on("click", function(){
    $('.popup-content').find('img').remove();
    $('.popup-comment').remove();
    $('.popup-content').append('<div class="popup-comment"></div>');
    popup.classList.toggle('is-show');
  });

  $('#js-black-bg').on("click", function(){
    $('.popup-content').find('img').remove();
    $('.popup-comment').remove();
    $('.popup-content').append('<div class="popup-comment"></div>');
    popup.classList.toggle('is-show');
  });
}
popupImage();
