FactoryBot.define do
  factory :user do
    email { "test@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    nickname { "test" }
  end

  factory :second_user, class: User do
    email { "second@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    nickname { "second" }
  end

  factory :incorrect_user, class: User do
    email { "incorrect@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    nickname { "incorrect" }
  end
end
