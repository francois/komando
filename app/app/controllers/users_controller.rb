class UsersController < ApplicationController

  def create
    CreateUserCommand.new(:attributes => params[:user]).run!
    redirect_to root_url

  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :action => :new
  end

end
