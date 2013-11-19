class Authentication < ActiveRecord::Base
  include Concerns::OmniauthConcern
  include Concerns::UserImagesConcern

  belongs_to :user

  validates :user_id, :provider, :proid, presence: true

  def name
    return nil unless oauth_data
    oauth_data['name'].presence || "#{oauth_data['first_name']} #{oauth_data['last_name']}".strip.presence || nil
  end

  def display_name
    return nil unless oauth_data
    oauth_data['first_name'].presence || oauth_data['nickname'].presence || oauth_data['name'].presence || oauth_data['username'].presence || nil
  end

  def profile_url
    oauth_data.try(:[], 'profile_url')
  end
end
