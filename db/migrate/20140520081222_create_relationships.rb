class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t| # 'relationships' is a join table
      t.integer :leader_id
      t.integer :follower_id
      t.timestamps
    end
  end
end
