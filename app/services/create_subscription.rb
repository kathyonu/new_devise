class CreateSubscription

  def self.call(plan, email_address, token)

    #Create Stripe Subscription
    stripe_sub = CreateStripeSubscription.call(
        plan,
        email_address,
        token
    )

    if !stripe_sub.nil?

      #Look for an user with this email. If not exists - create.
      user = User.find_by_email(email_address)
      if user.nil?
        Rails.logger.info "CreateSubscription: User is nil!"
        generated_password = Devise.friendly_token.first(8)
        user = User.new(:email => email_address, :password => generated_password, :password_confirmation => generated_password, :stripe_customer_id => stripe_sub.customer)
        if user.valid?
          Rails.logger.info "CreateSubscription: User is valid!"
        end
        user_saved = user.save
        if !user_saved
          Rails.logger.error "CreateSubscription: User not saved!"
          user.errors.each do |attribute, message|
            Rails.logger.error "  CreateSubscription: user.error = " + message
          end
        else
          Rails.logger.info "CreateSubscription: User saved"
        end
      else
        #TODO: This is a case of someone registering repeatedly (or a past user?). Need to think more on what to do.
        Rails.logger.info "CreateSubscription: User existed!"
      end

      if !user.nil? && !user.errors.any?
        #Create a new Subscription
        Rails.logger.info "CreateSubscription: user.email = " + user.email
        subscription = Subscription.new(
            plan: plan,
            user: user
        )
        subscription.stripe_id = stripe_sub.id
        subscription.save!
        Rails.logger.info "CreateSubscription: Subscription saved"
      else
        Rails.logger.info "CreateSubscription: Conditions not met to save Subscription"
      end
    else
      #TODO: Flash Message to be handled in controller
    end
    stripe_sub
  end
end