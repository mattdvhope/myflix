require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do # The convention is to use a dot for class methods; use # for instance methods
      it "makes a successful charge", :vcr do # To get this 'Stripe::Token ..etc', go to https://stripe.com/docs/api#create_card_token and copy/paste it (make sure it's set on Ruby).  Not the "EXAMPLE RESPONSE" below which is a JSON object which includes its token 'id'.
        Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # We need the secret key for this API call.
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 10,
            :exp_year => 2018,
            :cvc => "314"
          }
        ).id # This 'id' attribute is the token that we need to get from Stripe with a successful charge.  In this case, it comes from the "EXAMPLE RESPONSE" which is a JSON object which includes its token 'id'.  From... https://stripe.com/docs/api#create_card_token

        # We'll do the charge here going through our StripeWrapper...
        response = StripeWrapper::Charge.create( # To create a test charge, go to stripe.com/docs/api/ruby#create_charge to see an example. In our case, we'll only use 'amount', 'card' and 'description' since we'll always being 'usd'.
          amount: 999,
          card: token,
          description: "a valid charge"
        )

        expect(response.amount).to eq(999)
        expect(response.currency).to eq('usd')
      end
    end
  end
end