Fabricator(:message) do
  body { Faker::Lorem.sentence }
end
