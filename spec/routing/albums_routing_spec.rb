require "rails_helper"

RSpec.describe AlbumsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/albums").to route_to("albums#index")
    end

    it "routes to #show" do
      expect(get: "/albums/1").to route_to("albums#show", album_hash: "1")
    end

    it "routes to #create" do
      expect(post: "/albums").to route_to("albums#create")
    end
  end
end
