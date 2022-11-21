require 'rails_helper'

describe 'Client logs in' do
  it 'from the homepage' do
    visit root_path
    click_on 'Sou cliente'

    expect(current_path).to eq new_client_session_path
    within 'h2' do
      expect(page).to have_content 'Acesse sua conta'
    end
    within 'form' do
      expect(page).to have_field 'CPF'
      expect(page).to have_field 'Senha'
      expect(page).to have_button 'Acessar'
    end
  end

  it 'successfully' do
    create(:client, name: 'José')

    visit root_path
    click_on 'Sou cliente'
    fill_in 'CPF', with: '12345678910'
    fill_in 'Senha', with: '123456'
    click_on 'Acessar'

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Sou cliente'
    expect(page).not_to have_link 'Abrir conta'
    expect(page).to have_content 'Olá José'
    expect(page).to have_content 'Agência:'
    expect(page).to have_content 'Conta:'
  end

  it 'with invalid parameters' do
    create(:client, registration_number: '12345678910')

    visit new_client_session_path
    fill_in 'CPF', with: '10987654321'
    fill_in 'Senha', with: '123456'
    click_on 'Acessar'

    expect(current_path).not_to eq root_path
    expect(page).to have_content 'CPF ou senha inválidos.'
    expect(page).to have_field 'CPF', with: '10987654321'
  end

  it 'and logs out' do
    client = create(:client, name: 'José')

    login_as client
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).not_to have_content 'José'
    expect(page).not_to have_button 'Sair'
    expect(page).to have_link 'Sou cliente'
    expect(page).to have_link 'Abrir conta'
  end
end
