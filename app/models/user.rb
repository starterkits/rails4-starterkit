class User < ActiveRecord::Base
  include UserImagesConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable

   has_many :authentications, dependent: :destroy

   # Override Devise to allow for Authentication or password
   def password_required?
     return false if has_authentication?
     super
   end

   def has_authentication?
     (new_record? && authentications.present?) || authentications.find {|a| a.valid? }
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
