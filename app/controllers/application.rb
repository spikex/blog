class ApplicationController < ActionController::Base
  include Clearance::App::Controllers::ApplicationController

  helper :all

  protect_from_forgery

  include HoptoadNotifier::Catcher

end
