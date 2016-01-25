class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_user

  # GET /:id/edit
  def edit
    authorize @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        if params[:user][:pin].present?
          @user.phone_verify(params[:user][:pin])
        elsif @user.phone.present? and !@user.phone_verified
          @user.generate_pin
          TwilioClient.new.send_message(
            @user.phone,
            "Your Meeting PIN is #{@user.pin}. Please enter into your app to verify your number"
          )
        end
        format.html {
          redirect_to root_path,
          notice: 'Your profile was successfully updated.'
        }
        format.json { render :show }
      else
        format.html { render action: 'edit' }
        format.json {
          render json: @user.errors,
          status: :unprocessable_entity
        }
      end
    end
  end

  private

  def authorize user
    if @user != user
      flash[:notice] = "You are not allowed to do this"
      redirect_to root_url, status: :unprocessable_entity
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [ :name, :email, :avatar, :phone, :remind, :send_text, :pin, :frequency ]
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
