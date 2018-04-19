module BankAccountsHelper
  def get_sidebar_bank_accounts
    current_user.bank_accounts.order(name: :desc)
  end

  def area_chart_helper(values, options={})
    values = [values] unless values.is_a? Array

    defaults = {
      points: false,
      stacked: true,
      prefix: '$',
      thousands: ',',
      animation: true,
      library:
      {
        animation: {
          easing: 'easeOutQuart'
        },
      }
    }

    options = defaults.merge(options)

    area_chart values, options
  end

  def active? path
    "active" if current_page? path
  end
end
