require 'securerandom'

module GuidHelper
  def guid
    SecureRandom.uuid
  end
end
