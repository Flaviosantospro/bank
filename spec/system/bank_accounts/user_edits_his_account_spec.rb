require 'rails_helper'

describe 'User edits his account' do
  it 'from the homepage' do
    client = create(:client)

    login_as client
    visit root_path
    click_on 'Editar seus dados'

    expect(current_path).to eq edit_client_registration_path
    within 'h2' do
      expect(page).to have_content 'Edite seus dados'
    end
    within 'form' do
      expect(page).to have_field 'CPF', with: client.registration_number
      expect(page).to have_field 'Data de nascimento', with: client.birth_date
      expect(page).to have_field 'Nome', with: client.name
      expect(page).to have_field 'Sobrenome', with: client.surname
      expect(page).to have_field 'E-mail', with: client.email
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
      expect(page).to have_field 'Senha atual'
      expect(page).to have_button 'Atualizar'
    end
  end

  it 'successfully' do
    client = create(:client, birth_date: '13/08/1992', name: 'José', surname: 'da Silva')

    login_as client
    visit edit_client_registration_path
    fill_in 'Data de nascimento', with: '06/08/1992'
    fill_in 'Nome', with: 'João'
    fill_in 'Sobrenome', with: 'Carlos da Silva'
    fill_in 'Senha', with: '654321'
    fill_in 'Confirme sua senha', with: '654321'
    fill_in 'Senha atual', with: '123456'
    click_on 'Atualizar'

    updated_client = Client.last

    expect(page).to have_content 'A sua conta foi atualizada com sucesso.'
    expect(page).not_to have_content 'Olá José'
    expect(page).to have_content 'Olá João'
    expect(updated_client.birth_date.to_fs(:db)).to eq '1992-08-06'
    expect(updated_client.surname).to eq 'Carlos da Silva'
    expect(updated_client.valid_password?('654321')).to be true
  end

  it 'with incomplete parameters' do
    client = create(:client)

    login_as client
    visit edit_client_registration_path
    fill_in 'Data de nascimento', with: ''
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'Senha atual', with: '123456'
    click_on 'Atualizar'

    expect(current_path).not_to eq root_path
    expect(page).to have_content 'Não foi possível salvar cliente'
    expect(page).to have_content 'Data de nascimento não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
  end
end
