class ClientsController < ApplicationController
  def create
    @client = Client.new(client_params)
    redirect_to @client if @client.save
  end

  def show
    @client = Client.find(params[:id])
  end

  def edit
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def index
    @clients = Client.all.order(id: :desc)
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to @client
    else
      render 'edit'
    end
  end

  private

  def client_params
    params.require(:client).permit(:last_name, :first_name)
  end
end
