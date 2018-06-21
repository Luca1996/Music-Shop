class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # associations 
  has_many :products, dependent: :destroy	# if we delete an user, we delete all his products too

  # profile pic associated to the user
end
