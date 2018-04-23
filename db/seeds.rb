# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'test@user.com',
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf',
              confirmed_at: Time.zone.now)

chq = BankAccount.create!(user: User.first,
                    name: 'Cheque',
                    bank_number: '1234')

sav = BankAccount.create!(user: User.first,
                    name: 'Savings',
                    bank_number: '1234')

((Date.today - 6.months)..Date.today).each do |date|
  BankTransaction.create!(
      date: date,
      bank_account: chq,
      payee: Faker::Science.scientist,
      amount: date.tuesday? ? 1000 : -rand(300)
  )
end

((Date.today - 6.months)..Date.today).step(7).each do |date|
  BankTransaction.create!(
      date: date,
      bank_account: sav,
      payee: Faker::Science.scientist,
      amount: 100
  )
end
