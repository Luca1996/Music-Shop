class ActivitiesController < ApplicationController
	before_action :authenticate_user!

	def index
		@products = current_user.products
	end


end
