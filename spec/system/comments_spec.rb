require 'rails_helper'

RSpec.describe "Comment page", type: :system do
  describe "コメントページでの挙動" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      Rails.application.env_config['omniauth.auth'] = set_omniauth :google_oauth2
      visit login_path
      click_on 'Google Signin'
      expect(page).to have_content 'アカウント登録'
      click_button 'アカウント登録'
      click_button '新しいアルバムを作成する'
      sleep 3
      fill_in 'タイトルを追加', with: 'テストアルバム'
      file_path = Rails.root.join('spec', 'factories', 'test.jpg')
      attach_file('album_form_pictures', file_path, make_visible: true)
      click_button 'アップロードする'
      sleep 5
    end

    it 'コメントアイコンでコメント一覧が開ける', js: true do
      find('a.js-show-popup').click
      expect(page).to have_content 'コメント'
    end

    it '画像を押すとコメント一覧が開ける', js: true do
      find('img.js-show-popup').click
      expect(page).to have_content 'コメント'
    end

    it 'コメントアイコンからコメントが投稿できる', js: true do
      find('a.js-show-popup').click
      fill_in 'コメントする...', with: 'テストコメント'
      expect {
        click_on '投稿する'
        sleep 3
      }.to change(Comment, :count).by(1)
      expect(page).to have_content 'テストコメント'
      expect(page).to have_content 'mockuser'
      expect(page).to have_link nil, class: 'comment-delete'
    end

    it '画像アイコンからコメントが投稿できる', js: true do
      find('img.js-show-popup').click
      fill_in 'コメントする...', with: 'テストコメント'
      expect {
        click_on '投稿する'
        sleep 3
      }.to change(Comment, :count).by(1)
      expect(page).to have_content 'テストコメント'
      expect(page).to have_content 'mockuser'
      expect(page).to have_link nil, class: 'comment-delete'
    end

    it 'ゴミ箱アイコンからコメントが削除できる', js: true do
      find('img.js-show-popup').click
      fill_in 'コメントする...', with: 'テストコメント'
      click_on '投稿する'
      sleep 3
      find('a.comment-delete').click
      expect{
        page.accept_confirm '削除してよろしいですか？'
        expect(page).not_to have_content 'テストコメント'
      }.to change(Comment, :count).by(-1)
      expect(page).not_to have_content 'mockuser'
      expect(page).not_to have_link nil, class: 'comment-delete'
    end

    it 'コメント削除がキャンセルできる', js: true do
      find('img.js-show-popup').click
      fill_in 'コメントする...', with: 'テストコメント'
      click_on '投稿する'
      sleep 3
      find('a.comment-delete').click
      expect{
        page.dismiss_confirm '削除してよろしいですか？'
        expect(page).to have_content 'テストコメント'
      }.not_to change(Comment, :count)
      expect(page).to have_content 'mockuser'
      expect(page).to have_link nil, class: 'comment-delete'
    end

  end
end
