module StripeWrapper
  class Charge

    attr_reader :error_message, :response
    
    def initialize(options={}) # Use this hash so that we don't have to rely on the position of the 'response' and 'error_message' when we instantiate a new Charge object.
      @response = options[:response] # Use an instance variable to capture that state -- to capture Stripe's json object -- when we do 'new(response)' below.
      @error_message = options[:error_message] # To capture the error message from Stripe
    end

    def self.create(options={})
      # Stripe.api_key = ENV['STRIPE_SECRET_KEY'] is now in 'config/initializers/stripe.rb'  With it being there, it will be loaded when Rails loads, preventing clutter to our app code & our test code.
      begin # To make our rspec test, "makes a card declined charge" pass, we need to capture the exception with 'begin' and 'rescue'
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
        ) # We cannot just use the returned object which is a json object from Stripe.... Below, we will 'wrap' Stripe's json data into our own instantiated 'charge' object
        new(response: response) # Same as Charge.new(response, error_message) ; With a valid charge the error_message is 'nil' ; We're wrapping this response with our own object which is 'Charge'; creating a new instance of the Charge class. Note: Instead of writing, 'new(response, nil)' we can write this b/c we have the 'options={}' in 'initialize' (This feature is called 'named arguments', from Ruby 2.0).
      rescue Stripe::CardError => e
        new(error_message: e.message) # When the card is decined, it returns an object that does not have a 'response'. The 'error_message' is the '#message' from the Stripe::CardError's value. Note: Instead of writing, 'new(nil, e.message)' we can write this b/c we have the 'options={}' in 'initialize' (This feature is called 'named arguments', from Ruby 2.0).
      end
    end

    # Once we have wrapped Stripe's json response into our own Ruby 'charge' object, we now can write the '#successful?' method for that object.
    def successful?
      response.present? # 'successful' just means that Stripe's response is there
    end
  end
end