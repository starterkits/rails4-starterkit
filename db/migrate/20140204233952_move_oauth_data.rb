class MoveOauthData < ActiveRecord::Migration
  def up
    Authentication.unscoped.all.find_each do |auth|
      OauthDataCache.new(authentication: auth, data_json: auth.oauth_data_json).save!
    end
    remove_column :authentications, :oauth_data_json
  end

  def down
    add_column :authentications, :oauth_data_json, :text
    OauthDataCache.all.find_each do |data|
      data.authentication.oauth_data_json = data.data_json
      data.save!
    end
  end
end
