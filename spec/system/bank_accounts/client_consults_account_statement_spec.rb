require 'rails_helper'

describe 'Client consults bank account statement' do
  it 'without having made transactions on his account' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Extrato'

    expect(current_path).to eq statement_bank_accounts_path
    within 'h2' do
      expect(page).to have_content 'Extrato'
    end
    within 'form' do
      expect(page).to have_field 'Desde o dia'
      expect(page).to have_field 'até o dia'
      expect(page).to have_button 'Consultar'
    end
    expect(page).to have_content 'Seu saldo: R$ 0,00'
    expect(page).to have_content 'Não há transações no período'
    expect(page).to have_link 'Voltar'
    expect(page).not_to have_css 'table'
  end

  it 'successfully' do
    client = create(:client)
    create(:credit, credit_type: 'deposit', amount: 100_000, bank_account: client.bank_account, created_at: 15.days.ago)
    create(:debit, debit_type: 'transfer', amount: 10_000, bank_account: client.bank_account, created_at: 10.days.ago)
    create(:debit, debit_type: 'fee', amount: 500, bank_account: client.bank_account, created_at: 10.days.ago)
    create(:credit, credit_type: 'transfer', amount: 9_000, bank_account: client.bank_account, created_at: 5.days.ago)
    create(:debit, debit_type: 'withdraw', amount: 11_000, bank_account: client.bank_account, created_at: DateTime.current)

    login_as client
    visit root_path
    click_on 'Extrato'
    fill_in 'Desde o dia', with: 15.days.ago.strftime("%Y-%m-%d")
    fill_in 'até o dia', with: DateTime.current.strftime("%Y-%m-%d")
    click_on 'Consultar'

    expect(page).to have_content 'Seu saldo: R$ 875,00'
    within 'table' do
      expect(page).to have_content 'Data'
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Valor'
    end
    expect(page).to have_content I18n.l(DateTime.current.to_date)
    expect(page).to have_content 'Saque'
    within '#debit-0' do
      expect(page).to have_content 'R$ 110,00'
    end
    expect(page).to have_content I18n.l(5.days.ago.to_date)
    within '#credit-1' do
      expect(page).to have_content 'R$ 90,00'
    end
    expect(page).to have_content 'Taxa de transferência'
    within '#debit-2' do
      expect(page).to have_content 'R$ 5,00'
    end
    expect(page).to have_content I18n.l(10.days.ago.to_date)
    expect(page).to have_content 'Transferência entre contas'
    within '#debit-3' do
      expect(page).to have_content 'R$ 100,00'
    end
    expect(page).to have_content I18n.l(15.days.ago.to_date)
    expect(page).to have_content 'Depósito'
    within '#credit-4' do
      expect(page).to have_content 'R$ 1.000,00'
    end
    expect(page).not_to have_content 'Não há transações no período'
  end
end

