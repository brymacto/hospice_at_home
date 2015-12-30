class MatchProposalSerializer < ActiveModel::Serializer
  attributes :id, :day, :start_time, :end_time, :status

  has_one :client
  has_many :match_requests

  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end

  class MatchrequestSerializer < ActiveModel::Serializer
    has_one :volunteer
    attributes :status

    class VolunteerSerializer < ActiveModel::Serializer
      attributes :id, :first_name, :last_name
    end
  end
end
