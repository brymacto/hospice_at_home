class VolunteerSpecialty < ActiveRecord::Base
  has_and_belongs_to_many :volunteers
  belongs_to :match_proposal

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end