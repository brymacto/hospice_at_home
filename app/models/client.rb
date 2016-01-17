class Client < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  has_many :match_proposals, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    return if !has_address?
    "#{address}, #{city} #{province}, #{postal_code}"
  end

  private

  def has_address?
    address != nil && address.size > 0
  end
end
