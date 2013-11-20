# Common helpers included in ApplicationController and ApplicationHelper
module CommonHelper
  include DeviseRoutesHelper
  include GuidHelper
  include OauthHelper

  # Check if resource has a specific error.
  #
  # Requires I18n::Backend::Metadata is enabled.
  # Example:
  #   resource_has_error? resource, :email, :blank
  #   # Returns true if resource failed validates_presence_of for email field.
  def resource_has_error?(resource, field, error_key)
    error_key = error_key.to_s
    return false unless errors = resource.errors[field]
    errors.each do |msg|
      key = msg.try(:translation_metadata).try(:[], :key)
      return true if key && key.to_s.index(error_key)
    end
    false
  end

  # Add query parameters to a URL.
  #
  # Example:
  #   add_to_url('/a/b?test=1', data: 'yes')
  #   => '/a/b?test=1&data=yes'
  def add_to_url(url, params)
    uri = URI.parse(url)
    query = URI.escape params.collect{|k,v| "#{k}=#{v}" }.join('&')
    uri.query = [uri.query, query].compact.join('&')
    uri.to_s
  end
end
