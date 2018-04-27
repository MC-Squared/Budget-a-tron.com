class PagesController < ApplicationController
  def home
  end

  def about
  end

  def pricing
  end

  def features
    rnd = Random.new(1234)

    cheque_data = {}
    ((Date.today - 6.months)..Date.today).each do |date|
      cheque_data[date] = (5000 - rnd.rand(3000))
    end

    savings_data = {}
    savings_total = 0;
    ((Date.today - 6.months)..Date.today).each do |date|
      savings_total += 250 if date.monday?
      savings_data[date] = savings_total
    end

    @demo_net_worth_data =
      [
        {
          name: 'Cheque',
          data: cheque_data
        },
        {
          name: 'Savings',
          data: savings_data
        }
      ]

    @demo_cashflow_data =
      [
        [ 'Incoming',
          25000
        ],
        [ 'Outgoing',
          22795
        ]
      ]

    @demo_category_data =
      [
        [ 'Groceries',
          5526
        ],
        [ 'Restaurants',
          565
        ],
        [
          'Furniture',
          1598
        ],
        [
          'Baby',
          2256
        ]
      ]
  end
end
