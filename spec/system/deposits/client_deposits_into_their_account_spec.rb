require 'rails_helper'

describe 'Client deposits into their bank account' do
  it 'successfully' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Depositar'
    fill_in 'Valor R$', with: '1000'
    click_on 'Depositar'

    expect(current_path).to eq new_deposit_path
    expect(page).to have_content 'Depósito realizado com sucesso.'
    expect(page).to have_content 'Seu saldo: R$ 1.000,00'
  end

  it 'with incomplete parameters' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Depositar'
    fill_in 'Valor R$', with: ''
    click_on 'Depositar'

    expect(page).to have_content 'Não foi possível realizar o depósito'
    expect(page).to have_content 'Valor R$ deve ser maior ou igual a R$ 2'
    expect(page).to have_content 'Seu saldo: R$ 0,00'
  end
end
