class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :ensure_signup_complete
  def self.provides_callback_for(provider)
    class_eval %Q{
     def #{provider}
       @user = User.find_for_oauth(env["omniauth.auth"], current_user)
       if @user.persisted?
         sign_in_and_redirect @user, event: :authentication
         set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
       else
         redirect_to root_path, notice: 'Something went wrong'
       end
     end
    }
  end

  [:google, :slack].each do |provider|
    provides_callback_for provider
  end
end
