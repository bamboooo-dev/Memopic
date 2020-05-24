require 'rails_helper'

RSpec.describe "albums/show", type: :view do
  let(:user) { create(:user) }
  let(:unsharer){ create(:incorrect_user) }
  let(:picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) }
  let(:album) { create(:album, users: [ user ], pictures: [ picture ]) }

  before(:each) do
    assign(:album, album)
    assign(:pictures, album.pictures)
  end

  it "renders link to destroy album for sharer" do
    sign_in user
    render
    expect(rendered).to have_link('アルバム一覧に戻る', href: albums_path)
    expect(rendered).to have_link('このアルバムを削除する', href: album_path(album))
    expect(rendered).to have_link('このアルバムを編集する', href: edit_album_path(album))
  end

  it "don't render link to destroy album for unsharer" do
    sign_in unsharer
    render
    expect(rendered).to have_link('アルバム一覧に戻る', href: albums_path)
    expect(rendered).not_to have_link('このアルバムを削除する', href: album_path(album))
    expect(rendered).not_to have_link('このアルバムを編集する', href: edit_album_path(album))
  end
end
