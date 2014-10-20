class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :image_url

      ######################################################################
      # Devise

      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # End Devise
      ######################################################################

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute 'CREATE UNIQUE INDEX index_users_on_lower_email_index ON users (lower(email))'
      end
      dir.down do
        remove_index :users, :index_users_on_lower_email_index
      end
    end
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true
  end
end
