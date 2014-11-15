class Admin::PaymentsController < AdminsController # The controller has a module which is 'admin' ; These will be automatically wired up to the routes and views according to convention. In this particular case though, we're making this controller a child of AdminsController rather than ApplicationController b/c AdminsController has the 'require_admin' & 'require_user' methods which are needed in more than one 'admin' controller.

  def index
    @payments = Payment.all # NEVER do #all for a real app ; Work with your designer in doing pagination.
# binding.pry
  end

end
