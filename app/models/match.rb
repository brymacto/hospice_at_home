class Match < ActiveRecord::Base
  belongs_to :client
  belongs_to :volunteer
end