# This is used in 'models/stripe_wrapper.rb' and in "stripe_wrapper_spec.rb"
# We need the secret key for the Stripe API call.
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    # Define subscriber behavior based on the event object
    user = User.where(customer_token: event.data.object.customer).first # We find this from something like https://dashboard.stripe.com/test/events/evt_14yGM5LSkqll2z4UNJTiSI7n (hashes within hashes until we find 'customer', which gives us the customer token (i.e., "cus_58XQkIe8VR6QBy")). Remember that 'event' is what happens at Stripe when a customer is charged via a subscription, etc.
    user.activate! if (user && user.active? == false)
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id) # We're setting the associated user, the amount payed and the reference_id (which is the id of the 'charge'object coming back from Stripe, i.e. "ch_14yGM5LSkqll2z4U3KtyKBOu") with the Payment.
  end
end

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    user = User.where(customer_token: event.data.object.customer).first # We find this from something like https://dashboard.stripe.com/test/events/evt_14yGM5LSkqll2z4UNJTiSI7n (hashes within hashes until we find 'customer', which gives us the customer token (i.e., "cus_58XQkIe8VR6QBy")). Remember that 'event' is what happens at Stripe when a customer is charged via a subscription, etc.
    user.deactivate! # '#deactivate!' method in User.rb
  end
end