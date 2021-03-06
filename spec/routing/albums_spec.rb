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

    it "routes to #destroy" do
      expect(delete: "/albums/1").to route_to("albums#destroy", album_hash: "1")
    end

    it "routes to #edit" do
      expect(get: "/albums/1/edit").to route_to("albums#edit", album_hash: "1")
    end

    it "routes to #update" do
      expect(patch: "/albums/1").to route_to("albums#update", album_hash: "1")
    end

    it "routes to #export" do
      expect(get: "/albums/1/export").to route_to("albums#export", album_hash: "1")
    end

  end
end
