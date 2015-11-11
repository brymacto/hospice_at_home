class ClientsController < ApplicationController
  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    end
  end

  def new

  end

  private

  def client_params
    params.require(:client).permit(:last_name, :first_name)
  end
end
