class LoadMatch
  attr_reader :match, :match_proposal, :matches, :match_proposals

  def initialize(params, load_collection: false)
    @params = params
    @load_collection = load_collection
    if @load_collection
      @matches = load_matches
      @match_proposals = load_match_proposals
    else
      @match = load_match
      @match_proposal = load_match_proposal
    end
  end

  private

  def load_match
    match_id = match_params[:id]
    if match_id
      @match = Match.find(match_id)
    else
      @match = Match.new
    end
  end

  def load_matches
    load_volunteer_and_client
    if @volunteer
      @matches = Match.where(volunteer_id: @volunteer.id).includes(:client, :volunteer).order('clients.last_name ASC')
    elsif @client
      @matches = Match.where(client_id: @client.id).includes(:client, :volunteer).order('clients.last_name ASC')
    else
      @matches = Match.all.includes(:client, :volunteer).order('clients.last_name ASC')
    end
  end

  def load_match_proposal
    @match.match_request.match_proposal if @match.match_request
  end

  def load_match_proposals
    MatchProposal.all
      .includes(:client, :match_requests)
      .order('match_proposals.status ASC')
      .order('clients.last_name ASC')
  end

  def load_volunteer_and_client
    @volunteer = Volunteer.find(match_params[:volunteer_id]) if match_params[:volunteer_id]
    @client = Client.find(match_params[:client_id]) if match_params[:client_id]
  end

  def match_params
    @params.permit(:match, :id, :volunteer_id, :client_id)
  end
end
