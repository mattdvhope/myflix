class User < ActiveRecord::Base

  has_many :reviews
  has_many :queue_items, ->{ order('position') } # order is ASC by default

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue_item_positions # the rspec for this is in queue_items_controller_spec.rb ("normalizes the position numbers") b/c this method was originally written in 'queue_items_controller.rb' as a method for 'current_user'. It's being invoked in 'queue_items_controller.rb' now.
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

end