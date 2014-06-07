class User < ActiveRecord::Base

  has_many :queue_items, ->{ order('position') } # order is ASC by default
  has_many :reviews, ->{ order('created_at DESC') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id # It will go to the 'relationships' table and look for a foreign key called 'user_id' (Rails default), therefore we have to specify this as... foreign key: :follower_id --> :follower_id is THIS User's id (the current_user is the follower here).
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  before_create :generate_token

  def normalize_queue_item_positions # the rspec for this is in 'queue_items_controller_spec.rb' ("normalizes the position numbers") b/c this method was originally written in 'queue_items_controller.rb' as a method for 'current_user'. It's being invoked in 'queue_items_controller.rb' now.
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user) # Follows the leader (??) which is another user.
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user) # think of the '!' as meaning 'unless' here.
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end