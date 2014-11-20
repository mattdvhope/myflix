class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :amount # Always use integer data type for the amount for stripe, in pennies. Use of integers prevents ambiguity.
      t.string :reference_id # This is the id of the charge object; we need this reference_id so that we can map a payment on our server to a charge on Stripe's server.
      t.timestamps
    end
  end
end
