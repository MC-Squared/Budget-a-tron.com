FactoryBot.define do
  factory :bank_account do
    name "Demo Bank Account"
    bank_number "00-demo-555"
    user
  end

  factory :second_bank_account, class: BankAccount do
    name "My Second Account"
    bank_number "123-fake-456"
    user
  end
end
