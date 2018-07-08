class SettingsController < ApplicationController
	before_action :authenticate_user!

	# shows the settings of the current user
	def show
		@user = current_user
	end

	def change_avatar
		@user = current_user
		if !params.has_key?(:user)
			redirect_to settings_show_path
			flash.keep[:alert] = "Something wrong in changing avatar"
		elsif @user.update(pass_params)
			compress_image
			@user.save
			redirect_to settings_show_path
		else
			redirect_to settings_show_path
			notice[:alert] = "Something wrong in changing avatar"
		end
	end

	def change_mail
		user = current_user
		new_mail = params[:user][:email]
		user.email = new_mail
		if user.save
			redirect_to settings_show_path, notice: "Email changed"
		else 
			redirect_to settings_show_path, alert: "Not valid mail"
		end
	end

	def change_password
		user = current_user
		redirect_to settings_show_path, alert: "New password doesn't match with confirm" and return if params[:user][:password] != params[:user][:confirm]
		redirect_to settings_show_path, alert: "Wrong current password" and return if ! user.valid_password? params[:user][:curr_pass]
		new_pass = params[:user][:password]
		redirect_to settings_show_path, alert: "Password must be at least 8 characters" and return if new_pass.length < 8
		redirect_to settings_show_path, alert: "Password must be not longer than 128 characters" and return if new_pass.length > 128
		new_pass = BCrypt::Password.create(params[:user][:password])
		user.encrypted_password = new_pass
		user.save!
		redirect_to settings_show_path, notice: "Password changed successfully"
	end

	private
		def pass_params
			params.require(:user).permit(:curr_pass, :password, :confirm,:image)
		end

		def compress_image
            if !params[:user][:image].nil?
                b64 = Base64.encode64(params[:user][:image].read)
                @user.image = b64
            end
        end

end
