module Concerns::OmniauthConcern
  extend ActiveSupport::Concern

  included do
    # Omit oauth_data_json from default scope to save bits on the wire
    default_scope { select((column_names - ['oauth_data_json']).map { |column_name| "#{table_name}.#{column_name}" }) }
    scope :with_oauth, -> { select(:oauth_data_json) }
  end

  def update_from_omniauth(oauth)
    data, attrs = self.class.normalize_oauth(oauth)
    self.oauth_data = data
    update(attrs)
  end

  def oauth_data=(data)
    if self.class.needs_oauth_normalizing?(data)
      data, attrs = self.class.normalize_oauth(data)
    end
    @oauth_data = data
    self.oauth_data_json = data.to_json
  end

  def oauth_data
    @oauth_data ||= if self.try(:oauth_data_json).present?
      JSON.parse(self[:oauth_data_json])
    else
      auth = self.class.unscoped.with_oauth.where(id: id).first
      auth && auth.oauth_data_json.present? && JSON.parse(auth.oauth_data_json) || nil
    end
  end

  module ClassMethods
    def build_from_omniauth(oauth)
      data, attrs = normalize_oauth(oauth)
      auth = Authentication.new(attrs)
      auth.oauth_data = data
      auth
    end

    def needs_oauth_normalizing?(data)
      data.try(:[], 'credentials') || data.try(:[], 'info') || data.try(:[], 'extra')
    end

    def normalize_oauth(oauth)
      data = {
        provider:             oauth.provider.downcase,
        uid:                  oauth.uid,
        username:             oauth.extra.try(:[], 'raw_info').try(:[], 'username').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'screen_name'),
        nickname:             oauth.info.try(:[], 'nickname'),
        email:                oauth.info.try(:[], 'email').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'email'),
        name:                 oauth.info.try(:[], 'name'),
        first_name:           oauth.info.try(:[], 'first_name'),
        last_name:            oauth.info.try(:[], 'last_name'),
        image_url:            oauth.info.try(:[], 'image'),
        location:             oauth.info.try(:[], 'location').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'location').try(:[], 'name'),
        token:                oauth.credentials.token,
        refresh_token:        oauth.credentials.try(:[], 'refresh_token') || nil,
        secret:               oauth.credentials.try(:[], 'secret') || nil,
        expires:              oauth.credentials.try(:[], 'expires').presence || nil,
        expires_at:           oauth.credentials.try(:[], 'expires_at').presence || nil,
        verified:             oauth.extra.try(:[], 'raw_info').try(:[], 'verified'),
        bio:                  oauth.info.try(:[], 'description').presence ||
                              oauth.extra.try(:[], 'raw_info').try(:[], 'bio').presence ||
                              oauth.info.try(:[], 'headline')
      }.with_indifferent_access

      data[:urls] = Array(oauth.info.try(:[], 'urls')).select do |name,url|
        data[:profile_url] = url if name.downcase == oauth.provider.downcase || name == 'public_profile'
        name.underscore != oauth.provider && name.downcase != oauth.provider
      end
      [data, normalized_oauth_to_attributes(data)]
    end

    def normalized_oauth_to_attributes(data)
      @@attribute_symbols ||= self.attribute_names.map{|a| a.to_sym}.freeze
      data[:proid] = data[:uid]
      data[:expires_at] = Time.at(data[:expires_at]) if data[:expires_at].present?
      data.select{|k, v| @@attribute_symbols.include? k.to_sym}
    end
  end
end
