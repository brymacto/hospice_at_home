class ClientsController < ApplicationController
  include BreadcrumbGenerator

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    else
      flash.now[:error] = @client.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_client
    @matches = @client.matches
    @match_proposals = @client.match_proposals
    @load_map_js = true
    load_breadcrumbs(Client, @client)
  end

  def edit
    load_client
    load_breadcrumbs(Client, @client, :edit)
  end

  def new
    @client = Client.new
    load_breadcrumbs(Client, nil, :new)
  end

  def index
    @clients = Client.all.order(last_name: :asc).includes(:matches)
    load_breadcrumbs(Client)
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
      flash.now[:error] = @client.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  private

  def load_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:last_name, :first_name, :address, :city, :province, :postal_code)
  end
end
