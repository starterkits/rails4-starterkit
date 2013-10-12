class User < ActiveRecord::Base
  include UserImagesConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :async

   has_many :authentications, dependent: :destroy, validate: false

   # Override Devise to allow for Authentication or password
   def password_required?
     return false if has_authentication?
     super
   end

   # Return true if new_record? and an authentication is present
   # or record is persisted and at least one valid authentication exists.
   #
   # An invalid authentication is allowed for a new record since the record
   # needs to first be saved before the authentication.user_id can be set.
   def has_authentication?
     (new_record? && authentications.present?) || (authentications.find {|a| a.valid? }).present?
   end

   # Merge attributes from Authentication if User attribute is blank.
   #
   # If User has fields that do not match the Authentication field name,
   # modify this method as needed.
   def reverse_merge_attributes_from_auth(auth)
     auth.oauth_data.each do |k, v|
       self[k] = v if self.respond_to?("#{k}=") && self[k].blank?
     end
   end
end
