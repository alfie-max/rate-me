class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(params[:user])
    end

    def edit
      @user = User.find(params[:id])
    end

    def destroy
      user = User.find(params[:id])
    end
end
