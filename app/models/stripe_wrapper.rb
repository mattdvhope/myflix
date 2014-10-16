module StripeWrapper
  class Charge
    def self.create(options={})
      StripeWrapper.set_api_key
      response = Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card],
        description: options[:description]
      )
    end
  end

  def self.set_api_key # Put it outside of “Charge” b/c we’ll use it in other classes.
    Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # See 'config/application.yml'
  end
end