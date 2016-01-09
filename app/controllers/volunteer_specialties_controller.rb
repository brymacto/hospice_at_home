class VolunteerSpecialtiesController < ApplicationController
  def index
    @breadcrumb_links = [{path: volunteer_specialties_path, name: 'Specialties'}]
    @volunteer_specialties = VolunteerSpecialty.all.includes(:volunteers).order('volunteer_specialties.name ASC')
  end

  def new
    @breadcrumb_links = [{path: volunteer_specialties_path, name: 'Specialties'}, {path: new_volunteer_specialty_path, name: 'New specialty'}]
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
    @breadcrumb_links = [{path: volunteer_specialties_path, name: 'Specialties'}, {path: volunteer_specialty_path(@volunteer_specialty), name: @volunteer_specialty.name}]
    @volunteers = @volunteer_specialty.volunteers
  end

  def edit
    load_volunteer_specialty
    @breadcrumb_links = [{path: volunteer_specialties_path, name: 'Specialties'}, {path: volunteer_specialty_path(@volunteer_specialty), name: @volunteer_specialty.name}, {path: edit_volunteer_specialty_path, name: 'Edit'}]
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
