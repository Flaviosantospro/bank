FactoryBot.define do
  factory :client do
    registration_number { '12345678910' }
    name { 'José' }
    surname { 'da Silva' }
    birth_date { 30.years.ago.to_date }
    email { 'josesilva@bankatm.com' }
    password { '123456' }
  end
end
