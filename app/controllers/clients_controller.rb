class ClientsController < ApplicationController
  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    else
      flash[:error] = @client.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    load_client
    @matches = @client.matches
  end

  def edit
    load_client
  end

  def new
    @client = Client.new
  end

  def index
    @clients = Client.all.order(id: :desc)
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
      flash[:error] = @client.errors.full_messages.to_sentence
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
