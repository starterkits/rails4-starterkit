class Authentication < ActiveRecord::Base
  include Concerns::OmniauthConcern
  include Concerns::UserImagesConcern
  include Concerns::AuthenticationProvidersConcern

  belongs_to :user

  validates :user_id, :provider, :proid, presence: true

  def name
    return nil unless oauth_data
    oauth_data['name'].presence || "#{oauth_data['first_name']} #{oauth_data['last_name']}".strip.presence || nil
  end

  def display_name
    return nil unless oauth_data
    oauth_data['first_name'].presence || oauth_data['name'].presence ||
      oauth_data['nickname'].presence || username || oauth_data['username'].presence || nil
  end

  # Attempt to fill in oauth_data name fields for availabile data
  def populate_names
    return nil unless oauth_data.present?
    split_names = (name or '').split(' ')
    split_names.fill '', split_names.length..1
    oauth_data['first_name'] ||= split_names[0].presence or oauth_data['nickname'].presence or oauth_data['username'].presence
    oauth_data['last_name'] ||= split_names.drop(1).join(' ')
  end

  def profile_url
    oauth_data.try(:[], 'profile_url')
  end
end
