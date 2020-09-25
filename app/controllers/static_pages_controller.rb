class StaticPagesController < ApplicationController

  def top
    redirect_to albums_url if user_signed_in?
  end

  def howto
    @step_titles = %w(
      アルバムを作成する
      写真とプレイリストを入れる
      いいねやコメントして楽しむ！
      リンクで友達と共有する！
      自分だけの地図を作ろう！
    )
    @step_img_filename = %w(
      howto_1_newalbum.png
      howto_2_input.png
      howto_3_like.png
      howto_4_link.png
      howto_5_map.png
    )
  end
end
