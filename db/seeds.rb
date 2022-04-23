# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_by(email: "user@test.com")
user = User.create(email: "user@test.com", password: "test123", password_confirmation: "test123") unless user.present?

person_emitter = Person.find_or_create_by!(name: Faker::Name.first_name, rfc: Faker::Number.number(digits: 10))
person_receiver = Person.find_or_create_by!(name: Faker::Name.first_name, rfc: Faker::Number.number(digits: 10))

100.times do
  Invoice.find_or_create_by!(
    user: user,
    invoice_uuid: Faker::Invoice.reference,
    emitter: person_emitter,
    receiver: person_receiver,
    amount_cents: Faker::Number.number(digits: 5),
    amount_currency: Faker::Currency.code,
    emitted_at: Faker::Date.backward,
    expires_at: Faker::Date.backward
  )
end