require 'rails_helper'

describe 'Client transfers amount to another bank account' do
  it 'from the homepage' do
    client = create(:client)
    create(:credit, amount: 100_000, bank_account: client.bank_account)

    login_as client
    visit root_path
    click_on 'Transferir'

    expect(current_path).to eq new_transfer_path
    within 'h2' do
      expect(page).to have_content 'Transferência entre contas'
    end
    within 'form' do
      expect(page).to have_field 'CPF do favorecido'
      expect(page).to have_field 'Valor R$'
      expect(page).to have_button 'Transferir'
    end
    expect(page).to have_content 'Taxa de transferência:'
    expect(page).to have_content 'R$ 5,00 de segunda a sexta das 9 às 18 horas'
    expect(page).to have_content 'R$ 7,00 nos demais horários'
    expect(page).to have_content 'R$ 10,00 de taxa adicional em transferências acima de R$ 1.000,00'
  end

  it 'successfully' do
    first_client = create(:client)
    create(:credit, amount: 100_000, bank_account: first_client.bank_account)
    second_client = create(:client, registration_number: '10987654321', name: 'Maria', email: 'mariasilva@bankatm.com')

    login_as first_client
    visit root_path
    click_on 'Transferir'
    fill_in 'CPF do favorecido', with: '10987654321'
    fill_in 'Valor R$', with: '450'
    click_on 'Transferir'

    transfer_fee = Debit.last.amount
    balance = 550 - (transfer_fee.to_d / 100)

    expect(page).to have_content 'Transferência realizada com sucesso.'
    expect(page).to have_content "Seu saldo: R$ #{balance.to_i},00"
    expect(Client.last.bank_account.real_balance).to eq 450
  end

  it 'with invalid parameters' do
    first_client = create(:client)
    create(:credit, amount: 100_000, bank_account: first_client.bank_account)
    second_client = create(:client, registration_number: '10987654321', name: 'Maria', email: 'mariasilva@bankatm.com')

    login_as first_client
    visit root_path
    click_on 'Transferir'
    fill_in 'CPF do favorecido', with: '10987654321'
    fill_in 'Valor R$', with: ''
    click_on 'Transferir'

    expect(page).to have_content 'Não foi possível realizar a transferência'
    expect(page).to have_content 'Valor R$ deve ser maior ou igual a R$ 2'
    expect(page).to have_content 'Seu saldo: R$ 1.000,00'
  end

  it 'and the client does not exist' do
    first_client = create(:client)
    create(:credit, amount: 100_000, bank_account: first_client.bank_account)
    second_client = create(:client, registration_number: '10987654321', name: 'Maria', email: 'mariasilva@bankatm.com')

    login_as first_client
    visit root_path
    click_on 'Transferir'
    fill_in 'CPF do favorecido', with: '65432110987'
    fill_in 'Valor R$', with: '450'
    click_on 'Transferir'

    expect(page).to have_content 'Não foi possível realizar a transferência'
    expect(page).to have_content 'Cliente não encontrado ou conta bancária encerrada'
    expect(page).to have_content 'Seu saldo: R$ 1.000,00'
  end

  it 'with insufficient balance to pay the transfer fee' do
    first_client = create(:client)
    create(:credit, amount: 100_000, bank_account: first_client.bank_account)
    second_client = create(:client, registration_number: '10987654321', name: 'Maria', email: 'mariasilva@bankatm.com')

    login_as first_client
    visit root_path
    click_on 'Transferir'
    fill_in 'CPF do favorecido', with: '10987654321'
    fill_in 'Valor R$', with: '1000'
    click_on 'Transferir'

    expect(page).to have_content 'Não foi possível realizar a transferência'
    expect(page).to have_content 'Conta bancária não possui saldo suficiente'
    expect(page).to have_content 'Seu saldo: R$ 1.000,00'
  end
end
