require 'rails_helper'

RSpec.describe "albums/edit", type: :view do
  let(:user) { create(:user) }
  let(:unsharer){ create(:incorrect_user) }
  let(:picture){ build(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) }
  let(:album) { create(:album, users: [ user ], pictures: [ picture ]) }

  before(:each) do
    assign(:album, album)
    assign(:pictures, album.pictures)
  end

  it "renders button to update album for sharer" do
    sign_in user
    render
    expect(rendered).to have_selector('.fa-check')
  end
  
end
