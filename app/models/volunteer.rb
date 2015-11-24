class Volunteer < ActiveRecord::Base
  has_many :matches
  has_many :volunteer_availabilities
  
  def name
    "#{first_name} #{last_name}"
  end
end