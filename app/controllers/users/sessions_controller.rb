class Users::SessionsController < Devise::SessionsController
  respond_to :html, :js, :json

  def new
   super
  end

  def create
    user = User.find_for_oauth(env["omniauth.auth"], current_user)
    session[:user_id] = user.id
    if @user.persisted?
      render :status => 200, :json => { :user => { :email => @user.email, :name => @user.name } }
    else
      render :status => 401, :json => { :errors => alert }
    end
  end

  def destroy
    super
  end

  protected

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

end