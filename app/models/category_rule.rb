class CategoryRule < ApplicationRecord
  belongs_to :category
  delegate :user, to: :category

  after_commit :apply_rule_to_uncategorised_transactions

  def self.find_category_for_transaction(transaction)
    self.all.each do |rule|
      return rule.category if rule.matches_transaction? transaction
    end
    nil
  end

  def matches_transaction?(transaction)
    match_attributes = attributes.select do |attribute, match_with|
      attribute.starts_with?('match_') && !match_with.blank?
    end

    scope = BankTransaction.where(id: transaction.id)
    match_attributes.each do |match_attribute, match_with|
      attribute = match_attribute.gsub('match_', '')
      scope = scope.where("#{attribute} LIKE ?", "%#{match_with}%")
    end

    scope.exists?
  end

  private

    # TODO: Move category assignment to a background job
    def apply_rule_to_uncategorised_transactions
      self.user.bank_transactions.where(category: nil).each do |t|
        t.update(category: category) if matches_transaction? t
      end
    end
end
