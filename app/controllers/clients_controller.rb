class ClientsController < ApplicationController
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
    @breadcrumb_links = [{path: clients_path, name: 'Clients'}, {path: client_path(@client), name: @client.name}]
    @matches = @client.matches
    @match_proposals = @client.match_proposals
  end

  def edit
    load_client
    @breadcrumb_links = [{path: clients_path, name: 'Clients'}, {path: client_path(@client), name: @client.name}, {path: edit_client_path(@client), name: 'Edit'}]
  end

  def new
    @breadcrumb_links = [{path: clients_path, name: 'Clients'}, {path: new_client_path, name: 'New'}]
    @client = Client.new
  end

  def index
    @breadcrumb_links = [{path: clients_path, name: 'Clients'}]
    @clients = Client.all.order(last_name: :asc).includes(:matches)
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
    params.require(:client).permit(:last_name, :first_name)
  end
end
