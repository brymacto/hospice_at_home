class Client < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  def name
    "#{first_name} #{last_name}"
  end
end