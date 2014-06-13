class Invitation < ActiveRecord::Base
  validates_presence_of :recipient_name, :recipient_email, :message
end
