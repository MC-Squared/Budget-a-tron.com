module DeviseRedirection
  extend ActiveSupport::Concern

  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
