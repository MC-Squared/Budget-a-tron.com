class Category < ApplicationRecord
  belongs_to :user
  has_many :category_rules, dependent: :delete_all
  has_many :bank_transactions, dependent: :nullify

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: :user_id

  scope :ordered_by_name, -> { order(name: :asc) }
end
