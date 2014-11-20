class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin # In the rails console, choose the user(s) you want as 'admin' and then type, > matt.update_column(:admin, true) to update that user's column to be true.

private

  def require_admin
    if !current_user.admin? # "If the current user is not an 'admin'..." ; This 'admin?' method is made available by the 'add_column' of 'admin' (boolean) to the 'users' table using a migration.
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path
    end
  end

end
