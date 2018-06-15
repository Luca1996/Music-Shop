class SettingsController < ApplicationController
	before_action :authenticate_user!

	# shows the settings of the current user
	def show
		@user = current_user
	end

	def change_avatar
		user = current_user
		user.avatar.attach(params[:user][:avatar])
		redirect_to settings_show_path
	end

	def change_password
		user = current_user
		redirect_to settings_show_path, notice: "New password doens't match with confirm" and return if params[:user][:password] != params[:user][:confirm]
		redirect_to settings_show_path, notice: "Wrong current password" and return if ! user.valid_password? params[:user][:curr_pass]
		new_pass = params[:user][:password]
		redirect_to settings_show_path, notice: "Password must be at least 8 characters" and return if new_pass.length < 8
		redirect_to settings_show_path, notice: "Password must be not longer than 128 characters" and return if new_pass.length > 128
		new_pass = BCrypt::Password.create(params[:user][:password])
		user.encrypted_password = new_pass
		user.save!
		redirect_to settings_show_path, notice: "Password changed successfully"
	end

	private
		def pass_params
			params.require(:user).permit(:curr_pass, :password, :confirm)
		end

end
