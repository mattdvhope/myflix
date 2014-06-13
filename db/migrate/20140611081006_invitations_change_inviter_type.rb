class InvitationsChangeInviterType < ActiveRecord::Migration
  def change
    change_column :invitations, :inviter, :string
  end
end
