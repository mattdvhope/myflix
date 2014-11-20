class AddCustomerTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_token, :string # For use with webhooks.
  end
end
