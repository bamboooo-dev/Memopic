require 'rails_helper'

RSpec.describe "/albums", type: :request do
  # Album. As you add validations to Album, be sure to
  # adjust the attributes here as well.
  before do
    @user = create(:user)
    sign_in @user
    @incorrect_user = create(:incorrect_user)
  end

  let(:valid_album_name){ "test_album" }
  let(:picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) }
  let(:update_picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/update.png'), 'image/png')) }
  let(:playlist_name){ "test_playlist_name" }
  let(:playlist_url){ "https://music.apple.com/jp/playlist/test" }
  let(:invalid_album_name) { "" }

  describe "GET /index" do
    it "renders a successful response" do
      get albums_path
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let!(:album){ create(:album, users: [ @user ], pictures: [  picture, update_picture ]) }
    let(:favorite){ create(:favorite) }

    it "renders a successful response" do
      get album_path(album)
      expect(response).to be_successful
    end

    it "renders ordered by count of favorites" do
      update_picture.favorites << favorite
      get album_path(album)
      expect(assigns(:top_pictures)).to match([update_picture, picture])
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Album" do
        expect {
          post albums_path, params: { album_form: {
              name: valid_album_name,
              pictures: [ picture ],
              playlist_name: playlist_name,
              playlist_url: playlist_url
            }
          }
        }.to change(Album, :count).by(1)
      end

      it "redirects to the created album" do
        post albums_path, params: { album_form: {
            name: valid_album_name,
            pictures: [ picture ],
            playlist_name: playlist_name,
            playlist_url: playlist_url
          }
        }
        expect(response).to redirect_to(album_url(Album.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Album" do
        expect {
          post albums_path, params: { album_form: {
              name: invalid_album_name,
              pictures: [ picture ]
            }
          }
        }.to change(Album, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post albums_path, params: { album_form: {
            name: invalid_album_name,
            pictures: [ picture ]
          }
        }
        expect(response).to redirect_to(albums_url)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do

      it "updates the requested album" do
        @album = create(:album, users: [ @user ], pictures: [ picture ])
        expect {
          patch album_url(@album), params: { album_form: { name: "アップデート", pictures: [ update_picture ] } }
          @album.reload
        }.to change(@album.pictures, :count).by(1)
        expect(@album.name).to eq "アップデート"
      end

      it "updates with no picture" do
        @album = create(:album, users: [ @user ], pictures: [ picture ])
        patch album_url(@album), params: { album_form: { name: "アップデート", pictures: [] } }
        @album.reload
        expect(@album.name).to eq "アップデート"
      end

      it "redirects to the album" do
        @album = create(:album, users: [ @user ], pictures: [ picture ])
        patch album_url(@album), params: { album_form: { name: "アップデート", pictures: [ update_picture ] } }
        expect(response).to redirect_to(album_url(@album))
      end

    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        @album = create(:album, users: [ @user ], pictures: [ picture ])
        patch album_url(@album), params: { album_form: { name: "", pictures: [ update_picture ] } }
        expect(response).to redirect_to edit_album_url(@album)
      end
    end
  end

  describe "DELETE /albums/:album_hash" do
    it "destroys the correct user's requested album" do
      @album = create(:album, users: [ @user ])
      expect {
        delete album_path(@album)
      }.to change(Album, :count).by(-1)
    end

    it "can't destroy the incorrect user's requested album" do
      @album = create(:album, users: [ @user ])
      sign_out @user
      sign_in @incorrect_user
      expect {
        delete album_path(@album)
      }.to change(Album, :count).by(0)
    end

    it "redirects to the albums list" do
      @album = create(:album, users: [ @user ])
      delete album_path(@album)
      expect(response).to redirect_to(albums_url)
    end
  end

  describe "GET /export" do
    let!(:album){ create(:album, users: [ @user ], pictures: [  picture, update_picture ]) }

    it "responses successfully" do
      get export_album_path(album)
      expect(response).to be_successful
    end
  end
end
