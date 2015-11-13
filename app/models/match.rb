class Match < ActiveRecord::Base
  belongs_to :client
  belongs_to :volunteer

  def client_name
    Client.find(client_id).name
  end
  def volunteer_name
    Volunteer.find(volunteer_id).name
  end
end