FactoryBot.define do
  factory :bank_account do
    status { 'active' }
    agency_number { 1234 }
    account_number { 1234567 }
    association :client
  end
end
