class UsersController < ApplicationController
	before_filter :set_user

	def index
	end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    # puts "==="*222
    # puts @user.inspect
    # puts "==="*222
  end

	def add_email
    if params[:user] && params[:user][:email]
      current_user.email = params[:user][:email]
      # current_user.skip_reconfirmation! # don't forget this if using Devise confirmable

      # redirect_to :index
      
      respond_to do |format|
        if current_user.save
          format.html { redirect_to :root, notice: 'Your email address was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { @show_errors = true }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
    	render action: :add_user
    end

  end

  def update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    redirect_to new_imapsetting_path
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end
end
