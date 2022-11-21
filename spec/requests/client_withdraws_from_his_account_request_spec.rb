require 'rails_helper'

describe 'Client withdraws from his bank account' do
  it 'if authenticated' do
    get(new_withdraw_path)

    expect(response).to redirect_to new_client_session_path
  end

  it 'and sent amount in a POST request, if authenticated' do
    post(withdraws_path(
      params: {
        debit: {
          amount: '1000'
        }
      }
    ))

    expect(response).to redirect_to new_client_session_path
  end
end
