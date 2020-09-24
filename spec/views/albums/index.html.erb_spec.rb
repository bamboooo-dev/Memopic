require 'rails_helper'

RSpec.describe "albums/index", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    create(:album)
  end

  it "renders a list of albums" do
    sign_in user
    render
  end
end
