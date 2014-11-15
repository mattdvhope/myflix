class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, default: true # For may db's, the default for a boolean is 'false'.  So, for the existing record's the value for this column will now be 'true'. We're saying that all the existing users are going to be active users.
  end
end
