class VolunteerSpecialty < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :match_proposal
end