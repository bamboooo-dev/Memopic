FactoryBot.define do
  factory :album do
    name { "test_album" }
    album_hash { SecureRandom.alphanumeric(20) }
  end
end
