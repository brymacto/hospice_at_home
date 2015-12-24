class AddMatchProposalIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_proposal_id, :integer
  end
end
