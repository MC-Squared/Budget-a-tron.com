# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(email: 'test@user.com',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf',
              confirmed_at: Time.zone.now)

chq = BankAccount.create!(user: user,
                    name: 'Cheque')

sav = BankAccount.create!(user: user,
                    name: 'Savings')

5.times do
  Category.create!(user: user, name: Faker::Commerce.department(1))
end

((Date.today - 6.months)..Date.today).each do |date|
  BankTransaction.create!(
      date: date,
      bank_account: chq,
      payee: Faker::Science.scientist,
      amount: date.tuesday? ? 1000 : -rand(300),
      category: Category.where(id: rand(Category.count+1)).first
  )
end

((Date.today - 6.months)..Date.today).step(7).each do |date|
  BankTransaction.create!(
      date: date,
      bank_account: sav,
      payee: Faker::Science.scientist,
      amount: 100,
      category: Category.where(id: rand(Category.count+1)).first
  )
end
