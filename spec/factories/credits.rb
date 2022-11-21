FactoryBot.define do
  factory :credit do
    credit_type { 'deposit' }
    amount { 1_000 }
    association :bank_account
  end
end
