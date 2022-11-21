require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
  end

  describe 'status' do
    it { should define_enum_for(:status).with_values(active: 5, closed: 10) }
  end

  describe 'validations' do
    context 'uniqueness' do
      subject { build(:bank_account) }
      it { should validate_uniqueness_of(:account_number).case_insensitive }
    end

    context 'presence' do
      it { should validate_presence_of(:balance) }
    end

    context 'numericality' do
      it { should validate_numericality_of(:agency_number).only_integer.is_greater_than(0) }
      it { should validate_numericality_of(:account_number).only_integer.is_greater_than(0) }
      it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    end
  end

  describe 'methods' do
    context '#generate_agency_and_account_numbers' do
      it 'Generates a bank agency number when creating a new object' do
        bank_account = BankAccount.new
        bank_account.valid?
        expect(bank_account.agency_number).not_to be_nil
        expect(bank_account.account_number).not_to be_nil
      end
    end

    context '#real_balance' do
      it 'Converts balance in cents to balance in integers' do
        bank_account = build(:bank_account)
        bank_account.balance = 100_000
        expect(bank_account.real_balance).to eq 1_000
      end
    end
  end
end
