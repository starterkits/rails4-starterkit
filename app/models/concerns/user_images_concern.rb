module UserImagesConcern
  extend ActiveSupport::Concern

  def gravatar_url
    if email.blank?
      nil
    else
      "https://secure.gravatar.com/avatar/#{md5_email}"
    end
  end

  def md5_email
    require 'digest/md5'
    @md5_email = nil if email_changed?
    @md5_email ||= Digest::MD5.hexdigest(email.strip.downcase)
  end
end