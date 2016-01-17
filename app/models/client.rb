class Client < ActiveRecord::Base
  # include ActiveModel::Dirty
  # include ActiveModel::AttributeMethods
  # define_attribute_methods :address, :city, :province, :postal_code


  has_many :matches, dependent: :destroy
  has_many :match_proposals, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  geocoded_by :address
  after_validation :geocode,
                   :if => lambda { |client| client.address_changed? }

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    return if !has_address?
    "#{address}, #{city} #{province}, #{postal_code}"
  end

  def any_address_changed?
    address_changed? || city_changed? || province_changed? || postal_code_changed?
  end

  private

  def has_address?
    address != nil && address.size > 0
  end
end
