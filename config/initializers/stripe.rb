Rails.configuration.stripe = {
    publishable_key: RailsDevise.config.STRIPE_PUBLISHABLE_KEY,
    secret_key:      RailsDevise.config.STRIPE_SECRET_KEY
}

Stripe.api_key = \
  Rails.configuration.stripe[:secret_key]