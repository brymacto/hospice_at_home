class Volunteer < ActiveRecord::Base
  has_many :matches
  def name
    "#{first_name} #{last_name}"
  end
end