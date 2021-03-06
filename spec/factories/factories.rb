FactoryGirl.define do
  factory :client do
    first_name 'John'
    last_name 'Doe'
  end

  factory :volunteer, class: 'Volunteer' do
    first_name 'Jane'
    last_name 'Doe'
  end

  factory :availability do
    day 'monday'
    start_time 14
    end_time 16
    volunteer_id 1
  end

  factory :match do
    client_id 01
    volunteer_id 01
    day 'monday'
    start_time 9
    end_time 10
  end

  factory :match_proposal, class: 'MatchProposal' do
    day 'monday'
    start_time 9
    end_time 10
    client_id 01
    status 'pending'
  end

  factory :match_request, class: 'MatchRequest' do
    volunteer_id 01
    status 'pending'
    match_proposal_id 01
  end

  factory :specialty, class: 'Specialty' do
    name 'Expressive Arts'
  end
end
