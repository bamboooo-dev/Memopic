FactoryBot.define do
  factory :favorite do
    user { User.first }
    picture { Picture.last }
  end
end
