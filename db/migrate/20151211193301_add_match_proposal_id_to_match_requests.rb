class AddMatchProposalIdToMatchRequests < ActiveRecord::Migration
  def change
    add_column :match_requests, :match_proposal_id, :integer
  end
end
