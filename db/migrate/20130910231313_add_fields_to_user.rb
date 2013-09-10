class AddFieldsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string  :first_name, :null => false
      t.string  :last_name
      t.string  :image_url
    end
  end
end
