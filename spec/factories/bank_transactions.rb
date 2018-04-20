FactoryBot.define do
  factory :bank_transaction do
    date "2018-04-13"
    amount 1.5
    status "MyString"
    number 1
    payee "MyString"
    memo "MyString"
    address "MyString"
    bank_category "MyString"
    bank_account
  end

  factory :second_bank_transaction, class: BankTransaction do
    date "2018-04-13"
    amount 1.5
    status "MyString"
    number 1
    payee "MyString"
    memo "MyString"
    address "MyString"
    bank_category "MyString"
    bank_account
  end
end
