FactoryBot.define do
  factory :bank_account do
    name "Demo Bank Account"
    start_balance 100
    user
  end

  factory :second_bank_account, class: BankAccount do
    name "My Second Account"
    start_balance 100
    user
  end
end
