require 'rails_helper'

RSpec.describe AlbumsHelper do
  before do
    @user = create(:user)
  end

  let(:picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) }

  describe "pick_thumbpic" do
    it "render a valid thumbnails" do
      @albums = [ create(:album, :with_favorites, users: [ @user ], pictures: [ picture ]) ]
      include AlbumsHelper
      expect(pick_thumbpic).to eq [ @albums.first.pictures.second ]
    end
  end
end
