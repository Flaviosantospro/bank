require 'rails_helper'

describe 'User visits homepage' do
  it 'and see the name of the application' do
    visit root_path

    within 'header nav h1' do
      expect(page).to have_content 'Caixa Eletrônico'
    end
  end

  it 'and access options' do
    visit root_path

    expect(page).to have_content 'Selecione uma opção:'
    expect(page).to have_link 'Sou cliente'
    expect(page).to have_link 'Abrir conta'
  end
end
