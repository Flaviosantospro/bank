require 'rails_helper'

describe 'Client checks his bank account balance' do
  it 'if authenticated' do
    get(balance_bank_accounts_path)

    expect(response).to redirect_to new_client_session_path
  end
end
