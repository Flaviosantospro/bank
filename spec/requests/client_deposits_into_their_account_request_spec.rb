require 'rails_helper'

describe 'Client deposits into their bank account' do
  it 'if authenticated' do
    get(new_deposit_path)

    expect(response).to redirect_to new_client_session_path
  end

  it 'and sent amount in a POST request, if authenticated' do
    post(deposits_path(
      params: {
        credit: {
          amount: '1000'
        }
      }
    ))

    expect(response).to redirect_to new_client_session_path
  end
end
