class BankTransaction < ApplicationRecord
  belongs_to :bank_account
  delegate :user, to: :bank_account
  belongs_to :category, optional: true

  validates_presence_of :amount

  after_commit :update_transaction_category

  scope :sum_by_day, -> { group(:date).sum(:amount) }
  scope :sum_by_category, -> { group(:category).sum(:amount) }
  scope :positive_amount_sum, -> { where('amount > 0').sum(:amount) }
  scope :negative_amount_sum, -> { where('amount < 0').sum(:amount) }

  private

    # TODO: move category assignment to a background job
    def update_transaction_category
      unless attribute_present?('category_id')
        cat = CategoryRule.find_category_for_transaction(self)
        update(category: cat) unless self.category == cat
      end
    end
end
