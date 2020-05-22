FactoryBot.define do
  factory :picture do
    picture_name { Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'image/jpeg') }
    album
  end
end
