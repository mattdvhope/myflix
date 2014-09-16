class AddLargeCoverAndSmallCoverToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :large_cover_url # Removing columns from your db is dangerous, especially if you already have production data, b/c this will impact all the existing records in those tables. Usually you would do "data migration" before you would remove production columns.
    remove_column :videos, :small_cover_url
  end
end
