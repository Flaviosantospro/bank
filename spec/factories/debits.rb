FactoryBot.define do
  factory :debit do
    debit_type { 'withdraw' }
    amount { 1_000 }
    association :bank_account
  end
end
