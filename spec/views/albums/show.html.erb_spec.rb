require 'rails_helper'

RSpec.describe "albums/show", type: :view do
  let(:user) { create(:user) }
  let(:album) { create(:album) }
  before(:each) do
    sign_in user
    assign(:album, album)
    assign(:pictures, album.pictures)
  end

  it "renders attributes in <p>" do
    render
  end
end
