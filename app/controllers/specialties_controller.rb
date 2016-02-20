class SpecialtiesController < ApplicationController
  include BreadcrumbGenerator

  def index
    @specialties = Specialty.all.includes(:volunteers).order('specialties.name ASC')
    load_breadcrumbs(Specialty)
  end

  def new
    @specialty = Specialty.new
    load_breadcrumbs(Specialty, nil, :new)
  end

  def create
    specialty = Specialty.new(volunteer_specialty_params)
    if specialty.save
      redirect_to specialty
    else
      flash.now[:error] = specialty.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_specialty
    @volunteers = @specialty.volunteers
    load_breadcrumbs(Specialty, @specialty)
  end

  def edit
    load_specialty
    load_breadcrumbs(Specialty, @specialty, :edit)
  end

  def update
    load_specialty
    if @specialty.update(volunteer_specialty_params)
      redirect_to @specialty
    else
      flash.now[:error] = @specialty.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    load_specialty
    @specialty.destroy
    redirect_to specialties_path
  end

  private

  def load_specialty
    @specialty = Specialty.find(params[:id])
  end

  def volunteer_specialty_params
    params.require(:specialty).permit(:name)
  end
end
