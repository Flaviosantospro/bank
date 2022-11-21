require 'rails_helper'

RSpec.describe Debit, type: :model do
  describe 'associations' do
    it { should belong_to(:bank_account) }
  end

  describe 'debit_type' do
    it { should define_enum_for(:debit_type).with_values(withdraw: 5, transfer: 10, fee: 15) }
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
      describe '#check_bank_account_balance' do
        it 'valid if bank account has sufficient balance' do
          client = create(:client)
          create(:credit, amount: 100_000, bank_account: client.bank_account)
          debit = build(:debit, amount: 100_000, bank_account: client.bank_account)

          debit.valid?

          expect(debit.errors[:bank_account]).to be_empty
        end

        it 'invalid if bank account does not have sufficient balance' do
          client = create(:client)
          create(:credit, amount: 100_000, bank_account: client.bank_account)
          debit = build(:debit, amount: 150_000, bank_account: client.bank_account)

          debit.valid?

          expect(debit.errors[:bank_account]).to include('não possui saldo suficiente')
        end
      end

      describe '#check_active_bank_account' do
        it 'invalid if bank account is closed' do
          client = create(:client)
          create(:credit, amount: 100_000, bank_account: client.bank_account)
          client.bank_account.closed!
          debit = build(:debit, amount: 150_000, bank_account: client.bank_account)

          debit.valid?

          expect(debit.errors[:bank_account]).to include('encerrada')
        end
      end
    end
  end

  describe 'methods' do
    context '#debit_bank_account_balance' do
      it 'debit the amount from the bank account' do
        client = create(:client)
        create(:credit, amount: 100_000, bank_account: client.bank_account)
        create(:debit, amount: 50_000, bank_account: client.bank_account)

        expect(client.bank_account.balance).to eq 50_000
      end
    end
  end
end
