class CreatePlan
  def self.call(options={})
    Rails.logger.info "Creating plan " + options[:name].to_s + ".."
    plan = Plan.new(stripe_id: options[:stripe_id], name: options[:name])
    Rails.logger.info "Plan " + options[:name].to_s + " created!"

    if !plan.valid?
      Rails.logger.info "Plan not valid.."
      Rails.logger.info plan.errors.full_messages
      return plan
    end

    begin
      splan = Stripe::Plan.create(
          id: options[:stripe_id],
          amount: options[:amount],
          currency: options[:currency],
          interval: options[:interval],
          trial_period_days: options[:trial_period_days],
          name: options[:name]
      )
        Rails.logger.info "stripe insert went well.."
        Rails.logger.info splan.created
    rescue Stripe::StripeError => e
      Rails.logger.info "stripe insert did not go well.."
      if e.message != "Plan already exists."
        Rails.logger.error e.message
        plan.errors[:base] << e.message
        return plan
      else
        Rails.logger.info "Plan already exists."
        Rails.logger.error e.message
      end
    end

    plan.save

    return plan
  end
end