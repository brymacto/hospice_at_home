class SetMatchProposalIdToNull < ActiveRecord::Migration
  def change
    change_table :match_requests do |t|
      t.change :match_proposal_id, :integer, null: false
    end
  end
end
