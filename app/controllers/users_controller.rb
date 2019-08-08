class UsersController < ApplicationController
  before_action :user_is_logged_in?
  # before_action :correct_user?, :except => [:index]


  def index
    scopes = session[:oktastate][:extra][:raw_info][:Groups]
    print(scopes)
    @user = User.where(uid: params[:id]).first
    unless scopes.include? 'Admin'
      redirect_to '/unauthorized'
    end
    @users = User.all
  end

  def show
    client = Oktakit.new(token: ENV['OKTA_API_KEY'], organization: ENV["OKTA_ORG"])
    response, http_status = client.list_roles_assigned_to_user(params[:id])
    @roles = response
    client2 = Oktakit.new(token: ENV['OKTA_API_KEY'], organization: ENV["OKTA_ORG"])
    apps, http_status_2 = client2.get_assigned_app_links(params[:id])

    @apps = apps


  	if params.has_key?(:id)
      @user = User.where(uid: params[:id]).first
      # find_by argument: value
      # returns first match or nil
      # same as find, where find searches by id
      # Invite.find_by_invite_code params[:invite_code] is deprecated  
    else
    	@user = User.find(params[:id]) # First match or nil
    end
  end



end
