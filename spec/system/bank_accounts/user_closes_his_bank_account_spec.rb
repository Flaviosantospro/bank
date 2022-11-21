require 'rails_helper'

describe 'User closes his bank account' do
  it 'successfully' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Encerrar a minha conta'

    expect(page).to have_content 'Conta bancária encerrada com sucesso.'
    expect(page).not_to have_content 'Editar seus dados'
    expect(page).not_to have_content 'Encerrar a minha conta'
    expect(page).to have_button 'Reativar conta bancária'
  end

  it 'and reactivates it' do
    client = create(:client)
    client.bank_account.closed!

    login_as client
    visit root_path
    click_on 'Reativar conta bancária'

    expect(page).to have_content 'Conta bancária reativada com sucesso.'
    expect(page).to have_content 'Editar seus dados'
    expect(page).to have_content 'Encerrar a minha conta'
    expect(page).not_to have_button 'Reativar conta bancária'
  end
end
