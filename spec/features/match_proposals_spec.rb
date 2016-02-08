require 'rails_helper'
feature 'feature: match proposals' do
  let!(:test_client) { create(:client, first_name: 'Jonathan', last_name: 'Doe') }
  let!(:test_volunteer) { create(:volunteer, first_name: 'Susan', last_name: 'Smith') }

  scenario 'tab to match proposals from matches' do
    Capybara.current_driver = :selenium

    visit matches_path
    expect(page).to_not have_css ('#match_proposals_table')

    click_link 'Match proposals'

    expect(page).to have_css ('#match_proposals_table')

    Capybara.use_default_driver
  end

  scenario 'view list of match proposals' do
    Capybara.current_driver = :selenium

    create_match_proposal_and_request
    visit matches_path
    match_for_checking = { client: test_client, status: 'pending', day_and_time: 'Monday, 9 to 10' }

    click_link 'Match proposals'

    expect(page).to have_match_proposal (match_for_checking)

    Capybara.use_default_driver
  end

  scenario 'accept a match request' do
    Capybara.current_driver = :selenium

    create_match_proposal_and_request
    visit match_proposal_path(MatchProposal.first)

    expect(page).to have_css('td#meta_status', text: 'Pending')
    page.find('.request_accept').click

    expect(page).to have_css('td#meta_status', text: 'Accepted')

    Capybara.use_default_driver
  end

  scenario 'click through to a match from an accepted match request' do
    Capybara.current_driver = :selenium

    create_match_proposal_and_request
    visit match_proposal_path(MatchProposal.first)

    page.find('.request_accept').click

    click_link('View match')
    expect(page).to have_content('This match accepted from a match proposal')

    Capybara.use_default_driver
  end

  xscenario 'decline the only match request' do
    # TODO: this has not yet been implemented (proposal set to rejected once all the requests are rejected)
    Capybara.current_driver = :selenium

    create_match_proposal_and_request
    visit match_proposal_path(MatchProposal.first)

    page.find('.request_reject').click
    sleep(7)
    expect(page).to have_css('td#meta_status', text: 'Rejected')

    Capybara.use_default_driver
  end
end

RSpec::Matchers.define :have_match_proposal do |match|
  day_and_time = match[:day_and_time]
  client = match[:client].name
  status = match[:status]

  match do |page|
    page.find('#match_proposals_table tr:nth-child(2) td.match_proposals_table_day_and_time').has_content?(day_and_time) &&
      page.find('#match_proposals_table tr:nth-child(2) td.match_proposals_table_client').has_content?(client) &&
      page.find('#match_proposals_table tr:nth-child(2) td.match_proposals_table_status').has_content?(status.capitalize)
  end
end

def create_match_proposal_and_request
  params = ActionController::Parameters.new(
    'day' => 'monday',
    'start_time' => '9',
    'end_time' => '10',
    'client_id' => test_client.id,
    'status' => 'pending',
    "select_for_email_#{test_volunteer.id}" => 1
  )

  service = MatchProposalCreationService.new(params)
  expect(service.successful?).to be true
end
