FactoryBot.define do
  factory :picture do
    picture_name { [ Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg'), 'spec/factories/test.jpg') ] }
    association :album
  end
end
