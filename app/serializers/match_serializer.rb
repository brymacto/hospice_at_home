class MatchSerializer < ActiveModel::Serializer
  attributes :id, :day, :start_time, :end_time

  has_one :volunteer
  has_one :client

  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end

  class VolunteerSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end