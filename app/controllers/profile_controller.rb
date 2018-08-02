class ProfileController < ApplicationController
  def edit
    @user = current_user
    render :edit
  end

  def update    
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_edit, notice: 'Profile was updated'
    else
      render :edit
    end
  end
end