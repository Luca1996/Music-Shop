class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def github
		@user = User.from_omniauth(request.env["omniauth.auth"])
		#raise request.env["omniauth.auth"].inspect
		if @user.persisted?		# if user is not activated
			sign_in_and_redirect @user, :event => :authentication
			set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
		else
			session["devise.github_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
			#raise @user.inspect
		end
	end

	def failure
		redirect_to root_path
	end
end