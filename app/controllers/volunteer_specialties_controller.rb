class VolunteerSpecialtiesController < ApplicationController
  def index
    @volunteer_specialties = VolunteerSpecialty.all
  end
end