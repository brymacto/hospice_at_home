class MatchProposalSerializer < ActiveModel::Serializer
  DAY_NUMBERS = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  attributes :id, :day, :day_number, :start_time, :end_time, :status, :proposal_date, :match_requests_size

  has_one :client
  has_many :match_requests

  def proposal_date
    object.created_at.strftime('%F')
  end

  def match_requests_size
    object.match_requests.size
  end

  def day_number
    DAY_NUMBERS.fetch(object.day.to_sym, 9)
  end

  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end
