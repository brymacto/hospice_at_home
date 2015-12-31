class AddMatchRequestIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_request_id, :integer
  end
end
