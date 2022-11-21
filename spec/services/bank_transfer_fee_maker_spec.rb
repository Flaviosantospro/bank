require 'rails_helper'

describe BankTransferFeeMaker do
  context '.call' do
    describe 'creates the bank transfer fee with an amount of BRL 5.00' do
      it 'if made from Monday to Friday from 9 am to 6 pm' do
        datetime = DateTime.new(2022, 8, 22, 18, 0, 0, '-3')
        allow(DateTime).to receive(:now).and_return(datetime)
        client = create(:client)
        create(:credit, amount: 150_000, bank_account: client.bank_account)
        transfer = build(:debit, debit_type: 'transfer', amount: 100_000, bank_account: client.bank_account)

        result = BankTransferFeeMaker.call(transfer)
        transfer_fee = Debit.where(debit_type: 'fee').last.amount
        client_balance = Client.last.bank_account.balance

        expect(result).to be true
        expect(transfer_fee).to eq 500
        expect(client_balance).to eq 49500
      end
    end

    describe 'creates the bank transfer fee with an amount of BRL 7.00' do
      it 'if made from Monday to Friday between 6 pm and 9 am' do
        datetime = DateTime.new(2022, 8, 23, 8, 59, 59, '-3')
        allow(DateTime).to receive(:now).and_return(datetime)
        client = create(:client)
        create(:credit, amount: 100_000, bank_account: client.bank_account)
        transfer = build(:debit, debit_type: 'transfer', amount: 50_000, bank_account: client.bank_account)

        result = BankTransferFeeMaker.call(transfer)
        transfer_fee = Debit.where(debit_type: 'fee').last.amount
        client_balance = Client.last.bank_account.balance

        expect(result).to be true
        expect(transfer_fee).to eq 700
        expect(client_balance).to eq 49300
      end

      it 'if made on the weekend' do
        datetime = DateTime.new(2022, 8, 21, 12, 0, 0, '-3')
        allow(DateTime).to receive(:now).and_return(datetime)
        client = create(:client)
        create(:credit, amount: 150_000, bank_account: client.bank_account)
        transfer = build(:debit, debit_type: 'transfer', amount: 100_000, bank_account: client.bank_account)

        result = BankTransferFeeMaker.call(transfer)
        transfer_fee = Debit.where(debit_type: 'fee').last.amount
        client_balance = Client.last.bank_account.balance

        expect(result).to be true
        expect(transfer_fee).to eq 700
        expect(client_balance).to eq 49300
      end
    end

    describe 'creates the bank transfer fee with an additional amount of BRL 10.00' do
      it 'if the transfer amount is greater than BRL 1,000.00' do
        datetime = DateTime.new(2022, 8, 22, 9, 0, 0, '-3')
        allow(DateTime).to receive(:now).and_return(datetime)
        client = create(:client)
        create(:credit, amount: 150_000, bank_account: client.bank_account)
        transfer = build(:debit, debit_type: 'transfer', amount: 110_000, bank_account: client.bank_account)

        result = BankTransferFeeMaker.call(transfer)
        transfer_fee = Debit.where(debit_type: 'fee').last.amount
        client_balance = Client.last.bank_account.balance

        expect(result).to be true
        expect(transfer_fee).to eq 1500
        expect(client_balance).to eq 38500
      end
    end

    describe 'returns false' do
      it 'if there is not enough balance' do
        datetime = DateTime.new(2022, 8, 22, 18, 0, 0, '-3')
        allow(DateTime).to receive(:now).and_return(datetime)
        client = create(:client)
        create(:credit, amount: 100_000, bank_account: client.bank_account)
        transfer = build(:debit, debit_type: 'transfer', amount: 100_000, bank_account: client.bank_account)

        result = BankTransferFeeMaker.call(transfer)
        client_balance = Client.last.bank_account.balance

        expect(result).to be false
        expect(Debit.all).to be_empty
        expect(client_balance).to eq 100_000
      end
    end
  end
end
