# http://rubydoc.info/gems/premailer/Premailer:initialize

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
end
