Fabricator(:invitation) do
  recipient_name { Faker::Name.name.to_s }
  recipient_email { Faker::Internet.email.to_s }
  message { Faker::Lorem.paragraphs(2).to_s }
end