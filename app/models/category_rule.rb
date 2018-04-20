class CategoryRule < ApplicationRecord
  belongs_to :category
  delegate :user, to: :category
end
