FactoryGirl.define do
  factory :client do
    first_name 'John'
    last_name 'Doe'
  end

  factory :volunteer, class: 'Volunteer' do
    first_name 'Jane'
    last_name 'Doe'
  end

  factory :volunteer_availability do
    day 'monday'
    start_hour 14
    end_hour 16
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
end
