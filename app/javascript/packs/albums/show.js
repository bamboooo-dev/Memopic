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

$(function () {
  $('.button-new-playlist').on('click', () => {
    $('.form-new-playlist-link').slideToggle(alertFunc);
  });
  function alertFunc(){
    if ($(this).css('display') != 'none') {
      $(".button-new-playlist").text("▲ 閉じる");
      $(".button-new-playlist").css('color', 'orange')
      $(".button-new-playlist").css('background', 'white')
    }else{
      $(".button-new-playlist").text("プレイリストを追加する");
      $(".button-new-playlist").css('color', '#fff')
      $(".button-new-playlist").css('background', 'linear-gradient(45deg, #FFC107 0%, #ff8b5f 100%)')
    }
  };
});
