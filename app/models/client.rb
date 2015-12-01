class Client < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end
end
