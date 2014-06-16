class Invitation < ActiveRecord::Base
  include Tokenable # this Concern is from 'lib/tokenable.rb'
  belongs_to :user_who_invites, class_name: "User"
  validates_presence_of :recipient_name, :recipient_email, :message
end
