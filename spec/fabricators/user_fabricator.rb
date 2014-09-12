Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
  admin false # This ensures that an 'admin' must specifically be set to 'true' (below).
end

# You can inherit a Fabricator defined on a different model, and then overwrite it with or add new attributes.
Fabricator(:admin, from: :user) do # This will inherit all of the attributes from the Fabricator(:user) above.
  admin true # This overwrites the 'false' above.
end