Fabricator(:user) do
  username { Faker::Internet.user_name }
  email { Faker::Internet.email }
  password { 'badpassword' }
#  created_at { Time.current }
#  updated_at { Time.current }
end
