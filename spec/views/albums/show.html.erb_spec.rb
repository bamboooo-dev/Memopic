require 'rails_helper'

RSpec.describe "albums/show", type: :view do
  let(:user) { create(:user) }
  let(:unsharer){ create(:incorrect_user) }
  let(:picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) }
  let(:album) { create(:album, users: [ user ], pictures: [ picture ]) }

  before(:each) do
    assign(:album, album)
    assign(:top_pictures, album.pictures)
    assign(:bottom_pictures, [])
  end

  describe '適切なコンテンツ' do
    context '参加中のユーザーの場合' do

      before do
        sign_in user
      end

      it '一覧に戻るリンクがある' do
        render
        expect(rendered).to have_link 'アルバム一覧に戻る', href: albums_path
      end

      it "参加中のマークがある" do
        render
        expect(rendered).to have_content '参加中'
      end

      it "アルバムを削除するリンクがある" do
        render
        expect(rendered).to have_link 'このアルバムを削除する', href: album_path(album)
      end

      it "アルバムを編集するリンクがある" do
        render
        expect(rendered).to have_link 'このアルバムを編集する', href: edit_album_path(album)
      end

      it "エクスポートするリンクがある" do
        render
        expect(rendered).to have_link 'コラージュしてエクスポート', href: export_album_path(album)
      end

      it '画像が表示されている' do
        render
        expect(rendered).to have_selector 'img.js-show-popup'
      end

      it 'いいねボタンが表示されている' do
        render
        expect(rendered).to have_link nil, href: favorites_path(picture_id: picture.id)
      end

      it 'コメントボタンが表示されている' do
        render
        expect(rendered).to have_link nil, href: comments_path(picture_id: picture.id, content: 'icon')
      end

    end

    context '参加していないユーザーの場合' do

      before do
        sign_in unsharer
      end

      it '一覧に戻るリンクがある' do
        render
        expect(rendered).to have_link 'アルバム一覧に戻る', href: albums_path
      end

      it "参加するリンクがある" do
        render
        expect(rendered).to have_link '参加する', href: user_albums_path(album_id: album.id)
      end

      it "アルバムを削除するリンクがない" do
        render
        expect(rendered).not_to have_link 'このアルバムを削除する', href: album_path(album)
      end

      it "アルバムを編集するリンクがない" do
        render
        expect(rendered).not_to have_link 'このアルバムを編集する', href: edit_album_path(album)
      end

      it "エクスポートするリンクがない" do
        render
        expect(rendered).not_to have_link 'コラージュしてエクスポート', href: export_album_path(album)
      end

      it '画像が表示されている' do
        render
        expect(rendered).to have_selector 'img.js-show-popup'
      end

      it 'いいねボタンが表示されている' do
        render
        expect(rendered).to have_link nil, href: favorites_path(picture_id: picture.id)
      end

      it 'コメントボタンが表示されている' do
        render
        expect(rendered).to have_link nil, href: comments_path(picture_id: picture.id, content: 'icon')
      end

    end
  end
end
