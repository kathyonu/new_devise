class RegistrationsController < Devise::RegistrationsController
  before_filter :load_plans

  def new
    @subscription = Subscription.new
    @plan = Plan.find(params[:plan_id])
    super
  end

  def edit
    super
  end

  def destroy
    super
  end

  def cancel
    super
  end

# POST /resource
  def create
    build_resource(sign_up_params)

    generated_password = Devise.friendly_token.first(8)
    resource.password = generated_password

    # Here you call Stripe
    #result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:plan])

    Rails.logger.info "RegistrationsController trying to register with Stripe.."

    @stripe_sub = CreateSubscription.call(
        @plan,
        params[:email_address],
        params[:stripeToken]
    )
    #if result.successful?
    if !@stripe_sub.nil?
      Rails.logger.info "RegistrationsController registered with Stripe!"
      #TODO: add Stripe customer ID to user
      resource.save
    else
      Rails.logger.error "RegistrationsController failed to register with Stripe!"
      flash[:error] = "Could not register: either card details wrong or no connection to server"
    end

    yield resource if block_given?
    if resource.persisted?
      #TODO: store Subscription in the DB:

      subscription = Subscription.new(
          plan: plan,
          user: user
      )
      subscription.stripe_id = @stripe_sub.id
      subscription.save!

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end

    MyMailer.welcome(resource, {password: generated_password}).deliver if resource.persisted?

  end

  def update
    super
  end

  protected

  def load_plans
    @plans = Plan.all
    @plans.each do |row|
      Rails.logger.info "Looping through the Plans.."
      Rails.logger.info row.inspect
    end
  end
end