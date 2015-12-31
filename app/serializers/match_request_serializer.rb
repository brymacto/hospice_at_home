class MatchRequestSerializer < ActiveModel::Serializer
  has_one :volunteer
  attributes :status

  class VolunteerSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end
