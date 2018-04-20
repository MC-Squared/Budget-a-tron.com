class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :bank_accounts
  has_many :bank_transactions, through: :bank_accounts
  has_many :categories
  has_many :category_rules, through: :categories
end
