class PagesController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

  # Preview html email template
  def email
    render layout: 'emails/hero', nothing: true
  end

  def error
    redirect_to root_path if flash.empty?
  end
end
