require 'rails_helper'

describe 'Client consults bank account statement' do
  it 'if authenticated' do
    get(statement_bank_accounts_path(
      params: {
        start_date: '2022-08-09',
        end_date: '2022-08-24'
      }
    ))

    expect(response).to redirect_to new_client_session_path
  end
end
