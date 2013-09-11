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

  def oauth_data=(data)
    @oauth_data = data
    self.oauth_data_json = data.to_json
  end

  def oauth_data
    @oauth_data ||= if self[:oauth_data_json].present?
      JSON.parse(self[:oauth_data_json])
    else
      auth = self.class.unscoped.select('oauth_data_json').where(id: id).first
      auth && auth.oauth_data_json.present? && JSON.parse(auth.oauth_data_json) || nil
    end
  end

end
