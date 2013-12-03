# http://stackoverflow.com/questions/8215132/rails-dynamic-robots-txt-with-erb

class RobotsController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  layout false

  # Render a robots.txt file based on whether the request is in production
  # and is performed against a canonical url or not.
  # Prevent robots from indexing content served via a CDN twice.
  def index
    if Rails.env.production? and canonical_host?
      render 'allow'
    else
      render 'disallow'
    end
  end

  protected

  def canonical_host?
    @host_regex ||= Regexp.new(ENV['CANONICAL_HOST'])
    request.host =~ @host_regex
  end
end
