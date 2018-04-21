class BankTransaction < ApplicationRecord
  belongs_to :bank_account
  delegate :user, to: :bank_account
  belongs_to :category, optional: true

  validates_presence_of :amount

  scope :sum_by_day, -> { group(:date).sum(:amount) }
  scope :sum_by_category, -> { group(:category).sum(:amount) }

  def self.apply_categories_from_rules(category_rules)
    self.where(category: nil).each do |t|
      category = category_rules.find_category_for_transaction(t)
      t.update(category: category) unless category.nil?
    end
  end
end
