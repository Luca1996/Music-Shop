class User < ApplicationRecord
  
  # associations 
  has_many :products, dependent: :destroy	# if we delete an user, we delete all his products too

  # profile pic associated to the user
  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

	def self.from_omniauth(auth) 
	    where(provider: auth.provider, uid: auth.uid).first_or_create do |user| 
	      # NOTE: this is executed only at first login with oauht and sets
	      # the email associated to the github account as the following line specifies
	      user.email = auth.info.email || "#{auth.uid}@github.com"
	      #raise auth.info.inspect
	      user.password = Devise.friendly_token[0,20] 
	    end 
	end 
    
    def self.new_with_session(params, session) 
  	 	super.tap do |user| 
    		if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"] 
	      		user.email = data["email"] if user.email.blank? 
	    	end 
	 	end 
	end 


end
