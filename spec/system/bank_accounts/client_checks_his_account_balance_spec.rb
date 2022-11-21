require 'rails_helper'

describe 'Client checks his bank account balance' do
  it 'successfully' do
    client = create(:client)
    create(:credit, amount: 100_000, bank_account: client.bank_account)

    login_as client
    visit root_path
    click_on 'Saldo'

    expect(current_path).to eq balance_bank_accounts_path
    within 'h2' do
      expect(page).to have_content 'Saldo'
    end
    expect(page).to have_content 'R$ 1.000,00'
    expect(page).to have_link 'Voltar'
  end

  it 'without having made transactions on his account' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Saldo'

    expect(current_path).to eq balance_bank_accounts_path
    expect(page).to have_content 'Saldo'
    expect(page).to have_content 'R$ 0,00'
    expect(page).to have_link 'Voltar'
  end
end
