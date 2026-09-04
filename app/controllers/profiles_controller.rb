class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Το προφίλ ενημερώθηκε"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :bio, :avatar, course_ids: [], interest_ids: [])
  end
end