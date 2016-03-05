class ClientsController < ApplicationController
  include BreadcrumbGenerator

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    else
      load_flash_errors
      render 'new'
    end
  end

  def show
    load_client
    load_matches
    @load_map_js = true
    load_breadcrumbs(crumb_class:Client, crumb_instance: @client)
  end

  def edit
    load_client
    load_breadcrumbs(crumb_class:Client, crumb_instance: @client, crumb_actions: [:edit])
  end

  def new
    @client = Client.new
    load_breadcrumbs(crumb_class:Client, crumb_actions: [:new])
  end

  def index
    load_client(all: true)
    load_breadcrumbs(crumb_class:Client)
  end

  def destroy
    load_client
    @client.destroy
    redirect_to clients_path
  end

  def update
    load_client
    if @client.update(client_params)
      redirect_to @client
    else
      load_flash_errors
      render 'edit'
    end
  end

  private

  def load_client(all = false)
    return @clients = Client.all.order(last_name: :asc).includes(:matches, :match_proposals) if all
    @client = Client.find(params[:id])
  end

  def load_matches
    return if @client.nil?
    @matches = @client.matches
    @match_proposals = @client.match_proposals
  end

  def load_flash_errors
    flash.now[:error] = @client.errors.full_messages.to_sentence
  end

  def client_params
    params.require(:client).permit(:last_name, :first_name, :address, :city, :province, :postal_code)
  end
end
