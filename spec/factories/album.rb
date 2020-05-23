FactoryBot.define do
  factory :album do
    name { "test_album" }
    album_hash { SecureRandom.alphanumeric(20) }

    trait :with_favorites do
      after(:build) do |album|
        picture = create(:picture, picture_name: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg')) do |p|
          p.favoriters = album.users
        end
        album.pictures << picture
      end
    end
  end
end
