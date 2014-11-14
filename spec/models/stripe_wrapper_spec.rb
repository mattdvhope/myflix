require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 10,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id # This 'id' attribute is the token that we need to get from Stripe with a successful charge.  In this case, it comes from the "EXAMPLE RESPONSE" which is a JSON object which includes its token 'id'.  From... https://stripe.com/docs/api#create_card_token
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 10,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id # This 'id' attribute is the token that we need to get from Stripe with a successful charge.  In this case, it comes from the "EXAMPLE RESPONSE" which is a JSON object which includes its token 'id'.  From... https://stripe.com/docs/api#create_card_token
  end
  # describe StripeWrapper::Charge do
  #   describe ".create" do # The convention is to use a dot for class methods; use # for instance methods
  #     it "makes a successful charge", :vcr do # To get this 'Stripe::Token ..etc', go to https://stripe.com/docs/api#create_card_token and copy/paste it (make sure it's set on Ruby).  Not the "EXAMPLE RESPONSE" below which is a JSON object which includes its token 'id'.
  #       # Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # This is now in 'config/initializers/stripe.rb' ; With it being there, it will be loaded when Rails loads, preventing clutter to our app code & our test code.
  #       # We'll do the charge here going through our StripeWrapper...
  #       response = StripeWrapper::Charge.create( # To create a test charge, go to stripe.com/docs/api/ruby#create_charge to see an example. In our case, we'll only use 'amount', 'card' and 'description' since we'll always being 'usd'.
  #         amount: 999,
  #         card: valid_token,
  #         description: "a valid charge"
  #       )
  #       expect(response).to be_successful # or,...expect(response.successful?).to be_true
  #       # expect(response.amount).to eq(999) # We no longer need these two 'expect's b/c we only now want to check and see if they are '#successful?'
  #       # expect(response.currency).to eq('usd')
  #     end

  #     it "makes a card declined charge", :vcr do
  #       # We'll do the charge here going through our StripeWrapper...
  #       response = StripeWrapper::Charge.create( # To create a test charge, go to stripe.com/docs/api/ruby#create_charge to see an example. In our case, we'll only use 'amount', 'card' and 'description' since we'll always being 'usd'.
  #         amount: 999,
  #         card: declined_card_token,
  #         description: "an invalid charge"
  #       )
  #       expect(response).not_to be_successful # or,...expect(response.successful?).to be_false
  #     end
  #     it "returns the error message for declined charges", :vcr do
  #       # We'll do the charge here going through our StripeWrapper...
  #       response = StripeWrapper::Charge.create( # To create a test charge, go to stripe.com/docs/api/ruby#create_charge to see an example. In our case, we'll only use 'amount', 'card' and 'description' since we'll always being 'usd'.
  #         amount: 999,
  #         card: declined_card_token,
  #         description: "an invalid charge"
  #       )
  #       expect(response.error_message).to eq("Your card was declined.") # This error message is the generic one from Stripe. Before we'd rescued that error, we saw that wording in red in the console when we ran rspec.
  #     end
  #   end
  # end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        )
        expect(response).to be_successful
      end
      it "does not create a customer with declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )
        expect(response).not_to be_successful
      end
      it "returns the error message for declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        )
        expect(response.customer_token).to be_present
      end
    end
  end
end
