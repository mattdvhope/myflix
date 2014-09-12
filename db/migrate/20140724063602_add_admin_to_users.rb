class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean # This automatically adds an 'admin?' method to the 'user' model.
  end
end
