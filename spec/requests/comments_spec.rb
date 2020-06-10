require 'rails_helper'

RSpec.describe "Comments", type: :request do
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

  describe "GET /index" do
    it "renders a successful response" do
      get comments_path(picture_id: picture.id, clicked: 'icon')
      expect(response).to redirect_to(album_url(picture.album))
    end
  end

  context 'ユーザーがアルバムに参加している場合' do

    before do
      sign_in user
    end

    describe "POST /comments" do
      context "with valid parameters" do
        it "creates a new comment" do
          expect {
            post comments_path, params: {
              content: "テストコメント",
              picture_id: picture.id,
            }
          }.to change(Comment, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "does not create a new comment" do
          expect {
            post comments_path, params: {
              content: "",
              picture_id: picture.id,
            }
          }.not_to change(Comment, :count)
        end
      end
    end

    describe "DELETE /comments/:id" do

      before do
        post comments_path, params: {
          content: "テストコメント",
          picture_id: picture.id,
        }
      end

      it 'destroys existing comment' do
        expect {
          delete comment_path( picture.comments.first )
        }.to change(Comment, :count).by(-1)
      end

    end
  end

  context 'ユーザーがアルバムに参加していない場合' do

    before do
      sign_in second_user
    end

    describe "POST /comments" do
      context "with valid parameters" do
        it "creates a new comment" do
          expect {
            post comments_path, params: {
              content: "テストコメント",
              picture_id: picture.id,
            }
          }.to change(Comment, :count).by(1)
        end

        it "creates a user_album relationship" do
          expect {
            post comments_path, params: {
              content: "テストコメント",
              picture_id: picture.id,
            }
          }.to change(UserAlbum, :count).by(1)
        end
      end

      context "with invalid parameters" do
        it "doesn't create a new comment" do
          expect {
            post comments_path, params: {
              content: "",
              picture_id: picture.id,
            }
          }.not_to change(Comment, :count)
        end

        it "doesn't creates a user_album relationship" do
          expect {
            post comments_path, params: {
              content: "",
              picture_id: picture.id,
            }
          }.not_to change(UserAlbum, :count)
        end
      end
    end

    describe "DELETE /comments/:id" do

      before do
        sign_out second_user
        sign_in user
        post comments_path, params: {
          content: "テストコメント",
          picture_id: picture.id,
        }
        sign_out user
        sign_in second_user
      end

      it 'cannot destroy existing comment' do
        expect {
          delete comment_path( picture.comments.first )
        }.not_to change(Comment, :count)
      end

    end
  end
end
