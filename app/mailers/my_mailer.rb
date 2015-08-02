class MyMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def welcome(record, token, opts={})
    @plan = opts[:plan]
    @token = token
    devise_mail(record, :welcome, opts)
  end
end