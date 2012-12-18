Fabricator(:message) do
  body { Faker::Lorem.sentence }
  author { Faker::Name.name }
  lat -10.02342
  lng 11.02342
  created_at { Time.current }
end
