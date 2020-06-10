require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when not signed in" do
      it "renders login page" do
        get root_path
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "when signed in" do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "renders album index page" do
        get root_path
        expect(response).to be_successful
      end
    end
  end
end
