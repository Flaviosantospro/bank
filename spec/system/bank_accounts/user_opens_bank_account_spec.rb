require 'rails_helper'

describe 'User opens bank account' do
  it 'from the homepage' do
    visit root_path
    click_on 'Abrir conta'

    expect(current_path).to eq new_client_registration_path
    within 'h2' do
      expect(page).to have_content 'Abra sua conta'
    end
    within 'form' do
      expect(page).to have_field 'CPF'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Sobrenome'
      expect(page).to have_field 'Data de nascimento'
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
      expect(page).to have_button 'Abrir conta'
    end
  end

  it 'successfully' do
    allow(SecureRandom).to receive(:random_number).with(9999).and_return(1234)
    allow(SecureRandom).to receive(:random_number).with(9999999).and_return(1234567)

    visit new_client_registration_path
    fill_in 'CPF', with: '12345678910'
    fill_in 'Nome', with: 'José'
    fill_in 'Sobrenome', with: 'da Silva'
    fill_in 'Data de nascimento', with: '06/08/1992'
    fill_in 'E-mail', with: 'josesilva@bankatm.com'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Abrir conta'

    expect(page).not_to have_content 'Sou cliente'
    expect(page).not_to have_content 'Abrir conta'
    expect(page).to have_content 'Bem vindo! Conta aberta com sucesso.'
    expect(page).to have_content 'Olá José'
    expect(page).to have_content 'Agência: 1234'
    expect(page).to have_content 'Conta: 123456-7'
  end

  it 'with incomplete parameters' do
    visit new_client_registration_path
    fill_in 'CPF', with: ''
    fill_in 'Data de nascimento', with: '06/08/1992'
    fill_in 'Nome', with: 'José'
    fill_in 'Sobrenome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on 'Abrir conta'

    expect(current_path).not_to eq root_path
    expect(page).to have_content 'Não foi possível salvar cliente'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_field 'Nome', with: 'José'
    expect(page).to have_field 'Data de nascimento', with: '1992-08-06'
  end
end
