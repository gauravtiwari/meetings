class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_signup_complete, if: :user_signed_in?

  private
  def ensure_signup_complete
    return if action_name == 'edit' || action_name == 'update' || action_name == 'connect_slack'
    redirect_to edit_user_path(current_user) unless current_user.phone_verified?
    if current_user.phone_verified?
      redirect_to connect_slack_path unless current_user.slack_token.present?
    end
  end
end
