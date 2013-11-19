module Concerns::UserImagesConcern
  extend ActiveSupport::Concern

  included do
    # Default image sizes are the same as Twitter's.
    # https://dev.twitter.com/docs/user-profile-images-and-banners
    # Modify provider specific image methods as needed after changing IMAGE_SIZES.
    unless defined? IMAGE_SIZES
      IMAGE_SIZES = {
        tiny:   24,
        thumb:  48,
        large:  73
      }.freeze
    end
  end

  # ssl: true|false
  # size: :tiny|:thumb|:large
  def image_url(*opts)
    sized_image_url(self[:image_url], *opts) || gravatar_url(*opts)
  end

  def sized_image_url(url, size: :thumb, ssl: true)
    return nil unless url.present?
    type = image_url_type(url)
    return url if type == :url
    self.send("sized_#{type}_image_url", url, size: size, ssl: ssl)
  end

  def gravatar_url(ssl: true, size: :thumb)
    return nil unless self.try(:email).present?
    url = ssl ? 'https://secure.' : 'http://'
    "#{url}gravatar.com/avatar/#{md5_email}?s=#{image_size(size)}"
  end

  def image_size(size)
    image_sizes[size].presence || image_sizes[:thumb]
  end

  def image_sizes
    IMAGE_SIZES
  end

  def image_url_ssl(url)
    url.gsub(/^http:\/\//i, 'https://')
  end

  def md5_email
    require 'digest/md5'
    @md5_email = nil if email_changed?
    @md5_email ||= Digest::MD5.hexdigest(email.strip.downcase)
  end

  def image_url_type(url)
    return nil unless url.present?
    case url
    when /twitter_production|twimg\.com/
      :twitter
    when /graph\.facebook/
      :facebook
    when /licdn|linkedin/
      :linkedin
    else
      :url
    end
  end

  def sized_twitter_image_url(url, size: :thumb, ssl: true)
    # https://dev.twitter.com/docs/user-profile-images-and-banners
    size = case size
    when :tiny then '_mini'     # 24x24
    when :thumb then '_normal'  # 48x48
    when :large then '_bigger'  # 73x73
    else ''
    end
    if ssl
      url = image_url_ssl(url)
      url.gsub!(/([^\/]+)\.twimg\.com/, 'pbs.twimg.com')
    end
    url.gsub(/(_(bigger|normal|mini))?\.(png|gif|jpeg|jpg)/, "#{size}.\\3")
  end

  def sized_facebook_image_url(url, size: :thumb, ssl: true)
    # https://developers.facebook.com/docs/reference/api/using-pictures/
    url = image_url_ssl(url) if ssl

    # Facebook's default sizes serve images significantly faster
    # size = case size
    # when :tiny then 'square'    # 50x50
    # when :thumb then 'small'    # 50xHeight
    # when :normal then 'normal'  # 100xHeight
    # when :large then 'large'    # 200xHeight
    # else 'normal'
    # end
    # url.gsub(/picture(\?type=[^&]*)?/, "picture?type=#{size}")

    # Facebook supports on the fly image resizing
    width = height = image_sizes[size] || 100
    url.gsub(/picture(\?type=[^&]*)?/, "picture?width=#{width}&height=#{height}")
  end

  def sized_linkedin_image_url(url, size: :thumb, ssl: true)
    url = image_url_ssl(url.gsub(/[^\.\/]+\.(licdn|linkedin)\.com/, 'www.linkedin.com')) if ssl
    width = height = image_sizes[size] || 100
    url.gsub(/\/shrink_\d+_\d+\//, "/shrink_#{width}_#{height}/")
  end
end