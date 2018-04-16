class ApplicationController < ActionController::Base
  include Pundit
  include PunditRedirection
end
