require 'rails_helper'

RSpec.describe "/favorites", type: :request do

  let(:user) do
    create(:user)
  end
  let(:second_user) do
    create(:second_user)
  end
  let(:picture) do
    build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg'))
  end
  let!(:album) do
    Album.create(name:'test_album', album_hash: SecureRandom.alphanumeric(20), users: [ user ], pictures: [ picture ])
  end

  context 'ユーザーがアルバムに参加している場合' do

    before do
      sign_in user
    end

    describe "POST /favorites" do

      it 'creates a new favorite' do
        expect{
          post favorites_path, params: { picture_id: album.pictures.first.id }
        }.to change(Favorite, :count).by(1)
      end

      it "doesn't chage user_album relationship" do
        expect{
          post favorites_path, params: { picture_id: album.pictures.first.id }
        }.not_to change(UserAlbum, :count)
      end

    end

    describe "DELETE /favorites/:id" do

      before do
        post favorites_path, params: { picture_id: album.pictures.first.id }
      end

      it 'destroys existing favorite' do
        expect {
          delete favorite_path( album.pictures.first )
        }.to change(Favorite, :count).by(-1)
      end

    end

  end

  context 'ユーザーがアルバムに参加していない場合' do

    before do
      sign_in second_user
    end

    describe "POST /favorites" do

      it 'creates a new favorite' do
        expect{
          post favorites_path, params: { picture_id: album.pictures.first.id }
        }.to change(Favorite, :count).by(1)
      end

      it 'creates a user_album relationship' do
        expect{
          post favorites_path, params: { picture_id: album.pictures.first.id }
        }.to change(UserAlbum, :count).by(1)
      end

    end

    describe "DELETE /favorites/:id" do

      before do
        post favorites_path, params: { picture_id: album.pictures.first.id }
      end

      it 'destroys existing favorite' do
        expect {
          delete favorite_path( album.pictures.first )
        }.to change(Favorite, :count).by(-1)
      end

    end

  end

end
