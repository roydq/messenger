Fabricator(:message) do
  body { Faker::Lorem.sentence }
  username { Faker::Name.name }
  user_id { (rand(500)+1).to_s }
  coordinates [-10.02342, 11.02342]
  location { Faker::Address.city }
  created_at { Time.current }
end
