class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter # current user
      t.string :recipient_name
      t.string :recipient_email
      t.text :message
      t.timestamps
    end
  end
end
