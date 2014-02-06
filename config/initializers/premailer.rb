# http://rubydoc.info/gems/premailer/Premailer:initialize

# TODO: update premailer after ActionMailer preivew interceptor handling is available in Rails
# https://github.com/rails/rails/issues/13622

if defined? Premailer
  Premailer::Rails.config.merge!(
    preserve_styles: false,
    remove_ids:      true,
    remove_comments: true,
    remove_scripts:  true,
    base_url: ENV['MAIL_HOST'],
    verbose: Rails.env.development?,
    input_encoding: 'UTF-8',
    adapter: :nokogiri
  )

  # Temporary fix for preview_path getting set to nil by Premailer
  ActionMailer::Base.preview_path = Rails.application.config.action_mailer.preview_path
end
