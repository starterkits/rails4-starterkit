require 'securerandom'

module GuidHelper
  def guid
    "guid-#{SecureRandom.uuid}"
  end
end
