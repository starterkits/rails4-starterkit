class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :image_url

      ######################################################################
      # Devise

      ## Database authenticatable
      t.string :email,              null: false, default: '', index: { unique: true, case_sensitive: false }
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token, index: :unique
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
      t.string   :confirmation_token, index: :unique
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token, index: :unique # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # End Devise
      ######################################################################

      t.timestamps
    end
  end
end
