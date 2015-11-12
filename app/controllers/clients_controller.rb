class ClientsController < ApplicationController
  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    end
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def index
    @clients = Client.all
  end

  private

  def client_params
    params.require(:client).permit(:last_name, :first_name)
  end
end
