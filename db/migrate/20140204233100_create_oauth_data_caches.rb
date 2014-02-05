class CreateOauthDataCaches < ActiveRecord::Migration
  def change
    create_table :oauth_data_caches do |t|
    	t.belongs_to  :authentication
      t.text      	:data_json
      t.timestamps
    end
  end
end
