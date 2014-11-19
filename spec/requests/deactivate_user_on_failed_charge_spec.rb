require 'spec_helper'

# See www.relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec
describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_14z2FXLSkqll2z4UWUfJfbnO",
      "created" => 1416041383,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14z2FWLSkqll2z4UepsehLTE",
          "object" => "charge",
          "created" => 1416041382,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14z2DLLSkqll2z4U35agYLxE",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 11,
            "exp_year" => 2017,
            "fingerprint" => "EhiE6HA0eYcn65FF",
            "country" => "US",
            "name" => nil,
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
            "customer" => "cus_59K1FvNwoDZDz4"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14z2FWLSkqll2z4UepsehLTE/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_59K1FvNwoDZDz4",
          "invoice" => nil,
          "description" => "Payment to fail",
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
      "request" => "iar_59KvHJKTnoWUOl",
      "api_version" => "2014-09-08"
    }
  end

  it "deactivates a user with the web hook data from stripe for a charge failed", :vcr do # To make this work, we go to 'config/initializers/stripe.rb' and set upf 'charge.failed'
    alice = Fabricate(:user, customer_token: "cus_59K1FvNwoDZDz4")
    post "/stripe_events", event_data # This will hit our webhood endpoint.
    expect(alice.reload).not_to be_active # We expect 'alice' to be locked/deactivated. We could have a method '#active?' on the model 'alice' so that if the user is active he/she can sign in, use videos, etc.
                #reload is called here so that the db is reloaded and we now have a refreshed 'alice' record, otherwise the column 'active' would retain its default boolean value of 'true' ; The object 'alice' does not know that the record has been changed (when we'd posted '/stripe_events') in 'config/initializers/stripe.rb' (i.e. that the '#deactivate' method has been called on 'user')
  end
end