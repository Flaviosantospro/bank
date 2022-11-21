require 'rails_helper'

describe IntegerToCentsConverter do
  context '.call' do
    it 'Convert integer amount to cents' do
      amount = '1000'
      amount_in_cents = IntegerToCentsConverter.call(amount)
      expect(amount_in_cents).to eq 100_000
    end
  end
end
