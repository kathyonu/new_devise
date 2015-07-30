class RegistrationsController < Devise::RegistrationsController
  before_filter :load_plans

  def new
    Rails.logger.info "RegistrationsController#new: params[:plan_id] = " + params[:plan_id]
    @subscription = Subscription.new
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

    stripe_sub = CreateSubscription.call(
        @plan,
        params[:email_address],
        params[:stripeToken]
    )

    #resource_saved = resource.save
    if !stripe_sub.nil?
      user = User.find_by_email(params[:email_address])
      if !user.nil?
        resource_saved = true
        resource = user
      else
        Rails.logger.error "RegistrationsController#create user is nil!"
      end
      MyMailer.welcome(resource, {plan: @plan.id}).deliver_now if resource_saved
    else
      Rails.logger.error "RegistrationsController#create failed to register with Stripe!"
      flash[:error] = "Could not register: either card details wrong or no connection to server"
    end

    yield resource if block_given?
    if resource_saved
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
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end

=begin
# POST /resource
  def create
    build_resource(sign_up_params)
    resource_saved = nil

    generated_password = Devise.friendly_token.first(8)
    resource.password = generated_password

    #TODO: Strangely, the build_resource(sign_up_params) is empty, as a quick fix I re-initialise the email here:
    resource.email = params[:email_address]

    Rails.logger.info "RegistrationsController#create trying to register with Stripe for @plan.stripe_id = " + @plan.stripe_id
    Rails.logger.info "RegistrationsController#create: resource.email = " + resource.email

    @stripe_sub = CreateSubscription.call(
        @plan,
        params[:email_address],
        params[:stripeToken]
    )
    if !@stripe_sub.nil?
      Rails.logger.info "RegistrationsController#create registered with Stripe!"
      resource.stripe_customer_id = @stripe_sub.customer
      #TODO: What about a customer mistakenly registering twice? The following will cause a PK violation:
      resource_saved = resource.save
      Rails.logger.info "RegistrationsController#create: resource_saved = " + resource_saved.to_s
    else
      Rails.logger.error "RegistrationsController#create failed to register with Stripe!"
      flash[:error] = "Could not register: either card details wrong or no connection to server"
    end

    yield resource if block_given?

    if resource_saved

      Rails.logger.info "RegistrationsController#create: resource_saved for current_user.email = " + current_user.email
      subscription = Subscription.new(
          plan: @plan,
          user: current_user
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
      Rails.logger.error "RegistrationsController#create: NOT resource_saved!"
      Rails.logger.error "RegistrationsController#create: resource.errors = " + resource.errors.full_messages.to_s
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end

    MyMailer.welcome(resource, {plan: @plan.id}).deliver if resource_saved

  end
=end

  def update
    super
  end

  protected

  def load_plans
    @plans = Plan.all
    @plans.each do |row|
      Rails.logger.info "RegistrationsController#load_plans: Looping through the Plans.."
      Rails.logger.info row.inspect
    end

    @plan = Plan.find(params[:plan_id])
    if @plan.nil?
      Rails.logger.error "RegistrationsController#load_plans: plan is nil!"
    else
      Rails.logger.info "RegistrationsController#load_plans: plan is NOT nil!"
    end

  end
end