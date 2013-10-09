class Authentication < ActiveRecord::Base
  include OmniauthConcern

  belongs_to :user

  validates :user_id, :provider, :proid, presence: true

  default_scope { select((column_names - ['oauth_data_json']).map { |column_name| "#{table_name}.#{column_name}" }) }

  def name
    oauth_data.present? ? (oauth_data['name'] || "#{oauth_data['first_name']} oauth_data['last_name']") : nil
  end

  def profile_url
    oauth_data.present? ? oauth_data['profile_url'] : nil
  end
end
