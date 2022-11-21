require 'rails_helper'

RSpec.describe Credit, type: :model do
  describe 'associations' do
    it { should belong_to(:bank_account) }
  end

  describe 'credit_type' do
    it { should define_enum_for(:credit_type).with_values(deposit: 5, transfer: 10) }
  end

  describe 'validations' do
    context 'presence' do
      it { should validate_presence_of(:amount) }
    end

    context 'numericality' do
      it do
        should validate_numericality_of(:amount).is_greater_than_or_equal_to(200)
                                                .with_message('deve ser maior ou igual a R$ 2')
      end
    end

    context 'custom' do
      it 'invalid if bank account is closed' do
        client = create(:client)
        client.bank_account.closed!
        credit = build(:credit, amount: 100_000, bank_account: client.bank_account)

        credit.valid?

        expect(credit.errors[:bank_account]).to include('encerrada')
      end
    end
  end

  describe 'methods' do
    context '#credit_bank_account_balance' do
      it 'credit the amount to the bank account' do
        client = create(:client)
        create(:credit, amount: 100_000, bank_account: client.bank_account)

        expect(client.bank_account.balance).to eq 100_000
      end
    end
  end
end
