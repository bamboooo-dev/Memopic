require 'rails_helper'

RSpec.describe "Album index page", type: :system do
  describe "トップページでの挙動" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      Rails.application.env_config['omniauth.auth'] = set_omniauth :google_oauth2
      visit root_path
      click_on 'Google Signin'
      sleep 3
      click_button 'アカウント登録'
    end

    it '「新しいアルバムを作成する」ボタンが動く', js: true do
      expect(page).to have_content '新しいアルバムを作成する'
      expect(page).not_to have_content 'アップロードする'
      click_button '新しいアルバムを作成する'
      expect(page).to have_content 'アップロードする'
      click_button '閉じる'
      expect(page).not_to have_content 'アップロードする'
    end

    it 'ログアウトできる', js: true do
      click_on 'ログアウト'
      expect(page).to have_content 'ログイン', wait: 5
    end

    it 'アルバムを作成できる', js: true do
      click_button '新しいアルバムを作成する'
      sleep 3
      fill_in 'タイトルを追加', with: 'テストアルバム'
      file_path = Rails.root.join('spec', 'factories', 'test.jpg')
      attach_file('album_form_pictures', file_path, make_visible: true)
      expect(page).to have_content '1個の画像が選択されています'
      expect {
        click_button 'アップロードする'
        find '.btn-gradient-radius', text: '参加中', wait: 5
      }.to change(Album, :count).by(1)
      expect(page).to have_content 'テストアルバム'
      expect(page).to have_selector 'img'
      click_link 'アルバム一覧に戻る'
      expect(page).to have_content '新しいアルバムを作成する'
      expect(page).to have_selector 'img'
      expect(page).to have_content 'テストアルバム'
    end

    context '不正な値の場合' do
      before do
        click_button '新しいアルバムを作成する'
      end

      it 'アルバム名がないと作成できない', js:true do
        click_button 'アップロードする'
        expect(page).not_to have_content '参加中', wait: 5
      end

      it 'ファイルがないと作成できない', js:true do
        fill_in 'タイトルを追加', with: 'テストアルバム'
        click_button 'アップロードする'
        expect(page).not_to have_content '参加中', wait: 5
      end
    end
  end
end
