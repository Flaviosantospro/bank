class BankTransferFeeMaker < ApplicationService
  attr_reader :bank_transfer

  def initialize(bank_transfer)
    @bank_transfer = bank_transfer
  end

  def call
    @fee = Debit.new(debit_type: 'fee', amount: 0, bank_account: @bank_transfer.bank_account)
    fee_calculator

    if enough_balance
      @bank_transfer.save
      @fee.save
    else
      false
    end
  end

  private

  def business_hours
    datetime = DateTime.now.in_time_zone('Brasilia')
    datetime.change(hour: 9)..datetime.change(hour: 18)
  end

  def fee_calculator
    datetime = DateTime.now.in_time_zone('Brasilia')

    @fee.amount += if datetime.on_weekday? && business_hours.cover?(datetime)
                     500
                   else
                     700
                   end

    return unless @bank_transfer.amount > 100_000

    @fee.amount += 1_000
  end

  def enough_balance
    total_debt = Debit.new(bank_account: @bank_transfer.bank_account)
    total_debt.amount = @bank_transfer.amount + @fee.amount
    total_debt.valid?
  end
end
