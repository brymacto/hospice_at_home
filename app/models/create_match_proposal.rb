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
    match_proposal.match_requests.build
    match_proposal.save
    # if match_proposal.save
    #   match_request_volunteer_ids.each do |volunteer_id|
    #     MatchRequest.create!(volunteer_id: volunteer_id, status: 'pending', match_proposal_id: match_proposal.id)
    #   end
    # end

    match_proposal
  end

  def match_request_volunteer_ids
    @params.keys
      .select { |param| param.include?('select_for_email_') }
      .map { |param| param.split('_').last }
  end

  def match_proposal_params
    @params.permit(:day, :start_time, :end_time, :client_id, :status, {match_requests_attributes: [:volunteer_id, :status]} ).merge(client_id: @params[:client_id], status: 'pending')
  end
end