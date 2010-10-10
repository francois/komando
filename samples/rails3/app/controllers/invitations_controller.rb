class InvitationsController < ApplicationController

  def new
    @user = User.new
    render :signup
  end

  def create
    CreateUserCommand.new(:attributes => params[:user], :redis => StatsRedis).run!
    redirect_to root_url

  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :action => :signup
  end

  def show
    @user = User.find_invited_by_token(@token)
    render :action => :confirm
  end

  def update
    ConfirmUserInvitationCommand.new(:token      => params[:id],
                                     :attributes => params[:user],
                                     :redis      => StatsRedis).run!
    redirect_to root_url

  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :action => :confirm
  end

  private

  rescue_from ActiveRecord::RecordNotFound do
    render :file => Rails.root + "public/404.html", :status => :not_found
  end

end
