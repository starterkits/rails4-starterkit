# http://rubydoc.info/gems/premailer/1.7.9/Premailer:initialize

if defined? Premailer
  Premailer::Rails.config.merge!(
    preserve_styles: false,
    remove_ids:      true
  )
end
