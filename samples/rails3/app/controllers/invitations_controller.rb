class InvitationsController < ApplicationController

  def new
    render
  end

  def create
    CreateUserCommand.new(:attributes => params[:user], :redis => StatsRedis).run!
    redirect_to root_url

  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :action => :new
  end

  def edit
    render
  end

  def update
    ConfirmUserInvitationCommand.new(:attributes => params[:user], :redis => StatsRedis).run!
    redirect_to root_url

  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :action => :edit
  end

  private

  rescue_from ActiveRecord::RecordNotFound do
    render :file => Rails.root + "public/404.html", :status => :not_found
  end

end
