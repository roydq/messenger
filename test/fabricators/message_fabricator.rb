Fabricator(:message) do
  body { Faker::Lorem.sentence }
  username { Faker::Name.name }
  user_id { (rand(500)+1).to_s }
  lat -10.02342
  lng 11.02342
  created_at { Time.current }
end
