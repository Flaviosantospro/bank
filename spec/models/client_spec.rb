require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'associations' do
    it { should have_one(:bank_account) }
  end
  describe 'validations' do
    context 'uniqueness' do
      it { should validate_uniqueness_of(:registration_number) }
    end

    context 'presence' do
      it { should validate_presence_of(:registration_number) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:surname) }
      it { should validate_presence_of(:birth_date) }
      it { should validate_presence_of(:email) }
    end

    context 'numericality' do
      it { should validate_numericality_of(:registration_number).only_integer }
    end

    context 'length' do
      it { should validate_length_of(:registration_number).is_equal_to(11) }
    end

    context 'custom' do
      it 'valid if the client is over 18 years' do
        client = build(:client, birth_date: 18.years.ago.to_date)
        client.valid?
        expect(client.errors[:birth_date]).to be_empty
      end

      it 'invalid if the client is under 18 years of age' do
        client = build(:client, birth_date: 17.years.ago.to_date)
        client.valid?
        expect(client.errors[:birth_date]).to include('você precisa ter 18 anos ou mais.')
      end
    end
  end

  describe 'methods' do
    context '#bank_account_description' do
      it "Describes the client's bank agency number and bank account number" do
        client = create(:client)
        bank_account = create(:bank_account, agency_number: '1234', account_number: '1234567', client: client)

        expect(client.bank_account_description).to eq 'Agência: 1234 Conta: 123456-7'
      end
    end

    context '#set_bank_account' do
      it 'Set a bank account for a new client' do
        client = Client.create!(registration_number: '12345678910', name: 'José', surname: 'da Silva',
                                birth_date: 30.years.ago.to_date, email: 'josesilva@bankatm.com', password: '123456')
        expect(client.bank_account).to be_instance_of(BankAccount)
      end
    end
  end
end
