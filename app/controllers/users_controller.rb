require "byebug"

class UsersController < ApplicationController

    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_error
    end
  
    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end
  
    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: e.message}, status: :not_found
    end

    #GET /users
    def index
        @users = User.order('created_at')
        #render json: @users, status: :ok
        byebug
        render json: {
            status: 'successful',
            message: 'all user',
            data: @users
        },status: :ok
    end

    #GET /Users/{id}
    def show
        @user = User.find(params[:id])
        render json: {
            status: 'successful',
            message: 'user found',
            data: @user
        },status: :ok
    end

    #POST /Users sign up 
    def create
        @user = User.new(user_params)
        if @user.save
            render json:@user, status: :ok
        else
            render json:@user.errors, status: :unprocessable_entity
        end
    end

    #DELETE /users/{id}
    def destroy
        @user = User.find(params[:id])
        if @user.destroy 
            render json:@user, status: :ok
        else
            render json:@user.errors, status: :unprocessable_entity
        end
    end

    private
    #Deben ser los mismos parametros que definimos como required
    def user_params
        params.permit(:email,:name,:auth_token)
    end
end