class Category < ApplicationRecord
  belongs_to :user
  has_many :category_rules

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: :user_id
end
