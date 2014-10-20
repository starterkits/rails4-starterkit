class CreateOauthCaches < ActiveRecord::Migration
  def change
    create_table :oauth_caches, id: false, primary_key: :authentication_id do |t|
    	t.belongs_to  :authentication, 	null: false
      t.text      	:data_json, 			null: false
      t.timestamps
    end
  end
end
