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
    match_proposal.save
    match_proposal
  end

  def match_request_volunteer_ids
    @params.keys
      .select { |param| param.include?('select_for_email_') }
      .map { |param| param.split('_').last }
  end

  def match_proposal_params
    @params.permit(:day, :start_time, :end_time, :client_id, :status, {match_requests_attributes: [:volunteer_id, :status]} ).merge(client_id: @params[:client_id], status: 'pending').merge(match_request_attributes)
  end

  def match_request_attributes
    match_request_attributes = { :match_requests_attributes => { } }
    match_request_volunteer_ids.each_with_index do |volunteer_id, index|
      match_request_attributes[:match_requests_attributes][index] = { volunteer_id: volunteer_id, status: 'pending' }
    end
    match_request_attributes
  end
end