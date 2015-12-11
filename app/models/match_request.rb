class MatchRequest < ActiveRecord::Base
  belongs_to :match_proposal
  has_one :client, through: :match_proposal
  has_one :volunteer

end
