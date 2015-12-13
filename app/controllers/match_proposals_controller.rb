class CreateMatchProposal
  def initialize(params)
    @params = params
    @match_proposal = create_match_proposal
  end

  def successful?
    @match_proposal.errors.none?
  end

  attr_reader :match_proposal

  def error_messages
    @match_proposal.errors.full_messages.to_sentence
  end

  private

  def create_match_proposal
    match_proposal = MatchProposal.new(match_proposal_params)

    if match_proposal.save
      match_request_volunteer_ids.each do |volunteer_id|
        MatchRequest.create!(volunteer_id: volunteer_id, status: 'pending', match_proposal_id: match_proposal.id)
      end
    end

    match_proposal
  end

  def match_request_volunteer_ids
    @params.keys
      .select { |param| param.include?('select_for_email_') }
      .map { |param| param.split('_').last }
  end

  def match_proposal_params
    @params.permit(:day, :start_time, :end_time, :client_id, :status).merge(client_id: @params[:client_id], status: 'pending')
  end
end

class MatchProposalsController < ApplicationController
  def create
    service = CreateMatchProposal.new(params)
    if service.successful?
      @match_proposal = service.match_proposal
      redirect_to @match_proposal
    else
      flash.now[:error] = service.error_messages
      @day_options = Date::DAYNAMES.zip(Date::DAYNAMES.map(&:downcase))
      render 'matches/explorer'
    end
  end

  def show
    load_match_proposal
  end

  def destroy
    load_match_proposal
    @match_proposal.destroy
    redirect_to matches_path(initial_tab: 'match_proposal')
  end

  private

  def load_match_proposal
    @match_proposal = MatchProposal.find(params[:id])
  end
end
