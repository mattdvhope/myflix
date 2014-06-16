class AddUserWhoInvitesToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :user_who_invites_id, :integer
  end
end
