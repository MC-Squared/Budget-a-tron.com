class CategoryRule < ApplicationRecord
  belongs_to :category
  delegate :user, to: :category

  def self.find_category_for_transaction(transaction)
    all_transactions = transaction.user.bank_transactions

    self.all.each do |rule|
      match_attributes = rule.attributes.select do |attribute, match_with|
        attribute.starts_with?('match_') && !match_with.blank?
      end

      scope = all_transactions.where(id: transaction.id)
      match_attributes.each do |match_attribute, match_with|
        attribute = match_attribute.gsub('match_', '')
        scope = scope.where("#{attribute} LIKE ?", "%#{match_with}%")
      end

      if scope.exists?
        return rule.category
      end

    end
    nil
  end
end
