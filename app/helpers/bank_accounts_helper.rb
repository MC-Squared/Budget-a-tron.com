module BankAccountsHelper
  def get_sidebar_bank_accounts
    policy_scope(BankAccount).order(name: :asc)
  end

  def get_sidebar_categories
    policy_scope(Category).order(name: :asc)
  end

  def area_chart_helper(values, options={})
    values = [values] unless values.is_a? Array

    defaults = default_chart_options
    defaults[:stacked] = true
    options = defaults.merge(options)

    area_chart values, options
  end

  def line_chart_helper(values, options={})
    values = [values] unless values.is_a? Array
    defaults = default_chart_options
    defaults[:points] = true
    options = defaults.merge(options)

    line_chart values, options
  end

  def active? path
    "active" if current_page? path
  end

  def currency_color_class(amount)
    amount < 0 ? 'currency-negative' : 'currency-positive'
  end

  def category_link_helper(category)
    return link_to category.name, category if category
    '---'
  end

  private

    def default_chart_options
      {
        points: false,
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
    end
end
