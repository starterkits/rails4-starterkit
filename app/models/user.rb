class User < ActiveRecord::Base
  include UserImagesConcern

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable

   has_many :authentications, dependent: :destroy

end
