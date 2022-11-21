class CentsToIntegerConverter < ApplicationService
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def call
    @amount = @amount.to_d
    @amount /= 100
    @amount = @amount.to_i
  end
end
