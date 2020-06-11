require "rails_helper"

RSpec.describe FavoritesController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/favorites").to route_to("favorites#create")
    end

    it "routes to #destroy" do
      expect(delete: "/favorites/1").to route_to("favorites#destroy", id: '1')
    end
  end
end
