Fabricator(:user) do
  username { Faker::Internet.user_name }
end
