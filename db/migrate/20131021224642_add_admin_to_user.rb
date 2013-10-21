class AddAdminToUser < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up {
          t.boolean :is_admin
          t.index   :is_admin
        }
        dir.down { t.remove :is_admin}
      end
    end
  end
end
