class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_user, except: [:create]

  # GET /:id
  def show
    @problems = @user.problems
    .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.json {render 'problems/index'}
    end
  end

  # GET /:id/solutions
  def solutions
    @solutions = @user.solutions
    .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.json {render 'solutions/index'}
    end
  end

  # GET /:id/upvoted
  def upvoted
    votes = @user.votes.pluck(:votable_id)
    @problems = Problem.where(id: votes)
    .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.json {render 'problems/index'}
    end
  end

  # GET /:id/comments
  def comments
    if request.xhr?
      @comments = @user.comments
      .paginate(:page => params[:page], :per_page => 20)
    end

    respond_to do |format|
      format.html
      format.json {render 'comments/index'}
    end
  end

  # GET /:id/edit
  def edit
    authorize @user
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        format.html {
          redirect_to profile_path(@user),
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

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    authorize @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        sign_in(@user, :bypass => true)
        redirect_to new_problem_path || @user, notice: 'Post a new problem'
      else
        flash[:notice] = "Please fix these errors: #{@user.errors.full_messages.map{|m| m }.join(',')}"
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    authorize @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :location_list, :username, :avatar ]
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end

end
