class UsersController < ApplicationController
    before_action :require_logged_out, only:[:new]
    
    def create
        @user = User.new(user_params)
        if @user.save
            login(@user)
            redirect_to cats_url
        else
            render json: @user.errors.full_messages, status: 422
        end
    end

    def new
        @user = User.new
        render :new
    end

    def index
        @users = User.all 
        render :index
    end


    private
    def user_params
        params.require(:user).permit(:username, :password, :session_token)
    end
end