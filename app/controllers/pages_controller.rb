class PagesController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

  def home
  end

  # Dummy page for testing flows
  def test
  end

  # Preview html email template
  def email
    render layout: 'email', nothing: true
  end

  def error
    redirect_to root_path if flash.empty?
  end
end
