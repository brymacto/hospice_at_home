class Volunteer < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :volunteer_availabilities
  
  def name
    "#{first_name} #{last_name}"
  end
end