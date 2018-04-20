FactoryBot.define do
  factory :category_rule do
    category
    match_status "MyString"
    match_payee "MyString"
    match_memo "MyString"
    match_address "MyString"
    match_category "MyString"
  end
end
