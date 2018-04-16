module DeviseRedirection
  extend ActiveSupport::Concern

  def after_sign_in_path_for(resource)
    bank_accounts_path
  end
end
