class PagesController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

  # Preview html email template
  def email
    template = (params[:template] || 'hero').to_sym
    template = :hero unless [:email, :hero, :simple].include? template
    render layout: "emails/#{template}", nothing: true
    if params[:premail] == 'true'
      puts "\n!!! USING PREMAILER !!!\n\n"
      pre = Premailer.new(response_body[0],  warn_level: Premailer::Warnings::SAFE)
      reset_response
      # pre.warnings
      render text: pre.to_inline_css, layout: false
    end
  end

  def error
    redirect_to root_path if flash.empty?
  end
end
