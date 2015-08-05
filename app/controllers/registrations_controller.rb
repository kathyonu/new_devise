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

    generated_password = CreateSubscription.call(
        @plan,
        params[:email_address],
        params[:stripeToken]
    )

    #resource_saved = resource.save
    if !generated_password.nil?
      user = User.find_by_email(params[:email_address])
      if !user.nil?
        resource_saved = true
        resource = user
      else
        Rails.logger.error "RegistrationsController#create user is nil!"
      end
      #Rails.logger.info "RegistrationsController#create: resource.email = " + resource.email +", "
      MyMailer.welcome(resource, generated_password, {plan: @plan}).deliver_now if resource_saved
      #MyMailer.confirmation_instructions(resource, generated_password, {plan: @plan.id}).deliver_now if resource_saved
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