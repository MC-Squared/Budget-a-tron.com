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

  def donut_chart_helper(values, options={})
    values = [values] unless values.is_a? Array
    defaults = default_chart_options
    defaults[:donut] = true
    options = defaults.merge(options)

    pie_chart values, options
  end

  def column_chart_helper(values, options={})
    values = [values] unless values.is_a? Array
    defaults = default_chart_options
    defaults[:library][:scales] = {
      yAxes: [{
        ticks: {
          beginAtZero: true,
        }
      }]
    }
    options = defaults.merge(options)

    column_chart values, options
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

  def timespan_text(timespan)
    case timespan
    when :all
      'All time'
    else
      timespan.to_s.titleize + 'ly'
    end
  end

  def get_nonactive_timespans(active_timespan)
    timespans = [:all, :year, :month, :fortnight, :week]
    timespans.select { |t| t != active_timespan }
  end

  private

    def default_chart_options
      {
        defer: true,
        points: false,
        prefix: '$',
        thousands: ',',
        animation: true,
        messages: {empty: "No data"},
        library:
        {
          animation: {
            easing: 'easeOutQuart'
          },
        }
      }
    end
end
