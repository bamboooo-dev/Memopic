require 'rails_helper'

RSpec.describe "albums/index", type: :view do
  before(:each) do
    create(:album)
  end

  it "renders a list of albums" do
    render
  end
end
