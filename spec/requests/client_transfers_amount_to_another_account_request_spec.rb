require 'rails_helper'

describe 'Client transfers amount to another bank account' do
  it 'if authenticated' do
    get(new_transfer_path)

    expect(response).to redirect_to new_client_session_path
  end

  it 'and sent amount in a POST request, if authenticated' do
    post(transfers_path(
      params: {
        debit: {
          payee_registration_number: '12345678910',
          amount: '1000'
        }
      }
    ))

    expect(response).to redirect_to new_client_session_path
  end
end
