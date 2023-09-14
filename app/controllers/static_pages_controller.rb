class StaticPagesController < ApplicationController
	def home
		unless current_user
			return redirect_to new_user_session_path
		end	
		# redirect_to new_user_session_path
	end
end
