class ActivitiesController < ApplicationController
	before_action :authenticate_user!

	def index
		@products = current_user.products
		@orders = current_user.orders
	end


end
