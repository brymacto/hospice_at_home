class MatchProposalSerializer < ActiveModel::Serializer
  attributes :id, :day, :start_time, :end_time, :status

  has_one :client
  has_many :match_requests

  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end
