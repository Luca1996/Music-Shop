class ApplicationController < ActionController::Base
	before_action :ensure_logged_in, only: [:logout]


	# method called to logout, it previously check you are logged in
	def logout
		sign_out(@user)
		redirect_to '/', notice: "Logout success"
	end

	private

		def ensure_logged_in
			if !user_signed_in?
				redirect_to	'/', notice: "Already logged out"
			end
		end

end
