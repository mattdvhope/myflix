require 'spec_helper'

# See www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_14yGM5LSkqll2z4UNJTiSI7n", # You must convert the JSON to ruby hashes; you must use the hash-rocket symbol if the key is a string. All this data below came from https://dashboard.stripe.com/test/events/evt_14yGM5LSkqll2z4UNJTiSI7n (from the Webhook Details on the bottom of the page when I'd clicked on the 'success' arrow).
      "created" => 1415857277,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14yGM5LSkqll2z4U3KtyKBOu",
          "object" => "charge",
          "created" => 1415857277,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14yGM2LSkqll2z4UATmiV1uV",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 11,
            "exp_year" => 2018,
            "fingerprint" => "ScUXMLz4XUWM54rx",
            "country" => "US",
            "name" => nil, # You must convert the 'null' from JSON to 'nil' in Ruby.
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_58XQkIe8VR6QBy"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14yGM5LSkqll2z4U3KtyKBOu/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_14yGM5LSkqll2z4UuGNVnB3b",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_58XQkIe8VR6QBy",
          "invoice" => "in_14yGM5LSkqll2z4U7NMdylZu",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "fraud_details" => {
            "stripe_report" => nil,
            "user_report" => nil
          },
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_58XQdcIIC54x2N",
      "api_version" => "2014-09-08"
    }
  end

  it "creates a payment with the webhook from stripe for charge.succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_58XQkIe8VR6QBy") # From "customer" => "cus_58XQkIe8VR6QBy" above.
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice) # We need to set the associated user with the payment in 'config/initializers/stripe.rb' by looking for
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_58XQkIe8VR6QBy") # From "customer" => "cus_58XQkIe8VR6QBy" above.
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999) # We need to set the associated user with the payment in 'config/initializers/stripe.rb' by looking for
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_58XQkIe8VR6QBy") # From "customer" => "cus_58XQkIe8VR6QBy" above.
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_14yGM5LSkqll2z4U3KtyKBOu") # The 'reference_id' should be the id of the 'charge' object coming back from Stripe. Above you can see that the 'object' is actually called 'charge'; immediately before it you can find... "id" => "ch_14yGM5LSkqll2z4U3KtyKBOu"
  end
end