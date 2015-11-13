FactoryGirl.define do
  factory :client do
    first_name "John"
    last_name  "Doe"
  end

  factory :volunteer do
    first_name "Jane"
    last_name  "Doe"
  end

  factory :match do
    client_id 01
    volunteer_id 01
  end
end