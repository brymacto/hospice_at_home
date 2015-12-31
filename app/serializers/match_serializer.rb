class MatchSerializer < ActiveModel::Serializer
  DAY_NUMBERS = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  attributes :id, :day, :day_number, :start_time, :end_time

  has_one :volunteer
  has_one :client

  def day_number
    DAY_NUMBERS.fetch(object.day.to_sym, 9)
  end

  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end

  class VolunteerSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end
