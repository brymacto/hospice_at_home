class VolunteerSpecialtiesController < ApplicationController
  def index
    @volunteer_specialties = VolunteerSpecialty.all.includes(:volunteers).order('volunteer_specialties.name ASC')
  end

  def new
    @volunteer_specialty = VolunteerSpecialty.new
  end

  def create
    @volunteer_specialty = VolunteerSpecialty.new(volunteer_specialty_params)
    if @volunteer_specialty.save
      redirect_to @volunteer_specialty
    else
      flash.now[:error] = @volunteer_specialty.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_volunteer_specialty
    @volunteers = @volunteer_specialty.volunteers
  end

  def edit
    load_volunteer_specialty
  end

  def update
    load_volunteer_specialty
    if @volunteer_specialty.update(volunteer_specialty_params)
      redirect_to @volunteer_specialty
    else
      flash.now[:error] = @volunteer_specialty.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    load_volunteer_specialty
    @volunteer_specialty.destroy
    redirect_to volunteer_specialties_path
  end

  private

  def load_volunteer_specialty
    @volunteer_specialty = VolunteerSpecialty.find(params[:id])
  end

  def volunteer_specialty_params
    params.require(:volunteer_specialty).permit(:name)
  end
end
