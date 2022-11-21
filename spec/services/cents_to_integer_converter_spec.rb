require 'rails_helper'

describe CentsToIntegerConverter do
  context '.call' do
    it 'Convert amount in cents to integer' do
      amount = '100_000'
      integer_amount = CentsToIntegerConverter.call(amount)
      expect(integer_amount).to eq 1_000
    end
  end
end
