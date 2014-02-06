class OauthCache < ActiveRecord::Base
  self.primary_key = 'authentication_id'

  belongs_to :authentication, inverse_of: :oauth_cache
  validates :authentication, :data_json, presence: true

  def data=(new_data)
    self.data_json = new_data.to_json
    @data = new_data
  end

  def data
    @data ||= (data_json.present? and JSON.parse(data_json) or nil)
  end

  def data_json=(json)
    @data = nil
    self[:data_json] = nil
    begin
      JSON.parse(json)
      self[:data_json] = json
    rescue JSON::ParserError
    end
  end
end
