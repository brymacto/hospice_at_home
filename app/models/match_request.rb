class MatchRequest < ActiveRecord::Base
  belongs_to :match_proposal
  belongs_to :volunteer
  has_one :client, through: :match_proposal
  has_one :match, through: :match_proposal
end
