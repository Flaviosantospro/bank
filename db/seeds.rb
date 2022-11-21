# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
p '== Criando clientes =========================='

Client.create!(registration_number: '12345678910', name: 'José', surname: 'da Silva', birth_date: 30.years.ago.to_date,
               email: 'josesilva@bankatm.com', password: '123456')

second_client = Client.create!(registration_number: '10987654321', name: 'Maria', surname: 'da Silva',
                               birth_date: 30.years.ago.to_date, email: 'mariasilva@bankatm.com', password: '123456')

third_client = Client.create!(registration_number: '65432110987', name: 'Pedro', surname: 'Santos',
                              birth_date: 30.years.ago.to_date, email: 'pedrosantos@bankatm.com', password: '123456')

p '== Realizando movimentações =================='

second_client.bank_account.closed!

Credit.create!(credit_type: 'deposit', amount: 100_000, bank_account: third_client.bank_account,
               created_at: 15.days.ago)

Debit.create!(debit_type: 'transfer', amount: 10_000, bank_account: third_client.bank_account, created_at: 10.days.ago)

Debit.create!(debit_type: 'fee', amount: 500, bank_account: third_client.bank_account, created_at: 10.days.ago)

Credit.create!(credit_type: 'transfer', amount: 9_000, bank_account: third_client.bank_account, created_at: 5.days.ago)

Debit.create!(debit_type: 'withdraw', amount: 11_000, bank_account: third_client.bank_account,
              created_at: DateTime.now)
