class ApplicationController < ActionController::Base
  include Pundit
  include PunditRedirection
  include DeviseRedirection
end
