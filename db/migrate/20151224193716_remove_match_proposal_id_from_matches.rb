class RemoveMatchProposalIdFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :match_proposal_id, :integer
  end
end
