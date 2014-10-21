# This is used in 'models/stripe_wrapper.rb' and in "stripe_wrapper_spec.rb"
# We need the secret key for the Stripe API call.
Stripe.api_key = ENV['STRIPE_SECRET_KEY']