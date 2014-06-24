module Tokenable
  extend ActiveSupport::Concern # Rails’ way of organizing these types of cross-cutting concerns in our application.

  included do # Used in user.rb & invitation.rb...this makes this piece of knowledge DRY.
    before_create :generate_token

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
  end

end