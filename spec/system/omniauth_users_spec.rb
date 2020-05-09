require 'rails_helper'

RSpec.describe "Users through OmniAuth", type: :system do
  describe "OmniAuthのログイン" do
    context "googleでのログイン" do

      before do
        OmniAuth.config.mock_auth[:google] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth :google
        visit root_path
      end

      it "ログインをするとユーザー数が増える", js: true do
        expect {
          click_link 'Googleでログイン'
        }.to change(User, :count).by(1)
        expect(page).to have_content 'プロフィール設定'
        expect(page).to have_content 'Google アカウントによる認証に成功しました'
      end
    end
  end
end
